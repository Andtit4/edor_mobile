// src/auth/auth.service.ts
import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { User, UserRole } from '../entities/user.entity';
import { Prestataire } from '../entities/prestataire.entity';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { SocialAuthDto, SocialAuthResponseDto } from './dto/social-auth.dto';
import { EmailService } from '../email/email.service';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Prestataire)
    private prestataireRepository: Repository<Prestataire>,
    private jwtService: JwtService,
    private emailService: EmailService,
  ) {}

  async register(
    registerDto: RegisterDto,
  ): Promise<{ user: User | Prestataire; token: string }> {
    const { email, firstName, lastName, phone, password, role } = registerDto;

    // Vérifier si l'utilisateur existe déjà
    const existingUser = await this.userRepository.findOne({
      where: { email },
    });
    const existingPrestataire = await this.prestataireRepository.findOne({
      where: { email },
    });
    
    if (existingUser || existingPrestataire) {
      throw new ConflictException('Un utilisateur avec cet email existe déjà');
    }

    if (role === 'prestataire') {
      // Créer directement dans la table prestataire
      const prestataire = this.prestataireRepository.create({
        email,
        firstName,
        lastName,
        phone,
        password,
        role: 'prestataire',
        name: `${firstName} ${lastName}`,
        category: registerDto.category || 'Général',
        location: registerDto.location || registerDto.city || 'Non spécifié',
        description: registerDto.description || registerDto.bio || 'Prestataire de services',
        pricePerHour: registerDto.pricePerHour || 0,
        skills: registerDto.skills || [],
        categories: registerDto.categories || [],
        portfolio: registerDto.portfolio || [],
        profileImage: registerDto.profileImage,
        address: registerDto.address,
        city: registerDto.city,
        postalCode: registerDto.postalCode,
        bio: registerDto.bio,
        isAvailable: true,
        rating: 0,
        reviewCount: 0,
        completedJobs: 0,
        totalReviews: 0,
      });

      const savedPrestataire = await this.prestataireRepository.save(prestataire);

      // Générer le token JWT
      const token = this.jwtService.sign({
        sub: savedPrestataire.id,
        email: savedPrestataire.email,
        role: savedPrestataire.role,
      });

      // Envoyer l'email de bienvenue
      await this.emailService.sendWelcomeEmail(email, firstName, lastName, 'prestataire');

      // Retourner le prestataire sans le mot de passe
      const { password: _, ...prestataireWithoutPassword } = savedPrestataire;
      return { user: prestataireWithoutPassword as Prestataire, token };
    } else {
      // Créer dans la table user pour les clients
      const user = this.userRepository.create({
        email,
        firstName,
        lastName,
        phone,
        password,
        role: role as UserRole, // Convertir en enum UserRole
        profileImage: registerDto.profileImage,
        address: registerDto.address,
        city: registerDto.city,
        postalCode: registerDto.postalCode,
        bio: registerDto.bio,
        skills: registerDto.skills,
        categories: registerDto.categories,
      });

      const savedUser = await this.userRepository.save(user);

      // Générer le token JWT
      const token = this.jwtService.sign({
        sub: savedUser.id,
        email: savedUser.email,
        role: savedUser.role,
      });

      // Envoyer l'email de bienvenue
      await this.emailService.sendWelcomeEmail(email, firstName, lastName, 'client');

      // Retourner l'utilisateur sans le mot de passe
      const { password: _, ...userWithoutPassword } = savedUser;
      return { user: userWithoutPassword as User, token };
    }
  }

  async login(loginDto: LoginDto): Promise<{ user: User | Prestataire; token: string }> {
    const { email, password } = loginDto;

    // Chercher d'abord dans la table prestataire
    let prestataire = await this.prestataireRepository.findOne({ where: { email } });
    if (prestataire) {
      const isPasswordValid = await prestataire.validatePassword(password);
      if (!isPasswordValid) {
        throw new UnauthorizedException('Email ou mot de passe incorrect');
      }

      const token = this.jwtService.sign({
        sub: prestataire.id,
        email: prestataire.email,
        role: prestataire.role,
      });

      const { password: _, ...prestataireWithoutPassword } = prestataire;
      return { user: prestataireWithoutPassword as Prestataire, token };
    }

    // Sinon chercher dans la table user
    const user = await this.userRepository.findOne({ where: { email } });
    if (!user) {
      throw new UnauthorizedException('Email ou mot de passe incorrect');
    }

    const isPasswordValid = await user.validatePassword(password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Email ou mot de passe incorrect');
    }

    const token = this.jwtService.sign({
      sub: user.id,
      email: user.email,
      role: user.role,
    });

    const { password: _, ...userWithoutPassword } = user;
    return { user: userWithoutPassword as User, token };
  }

  async findById(id: string): Promise<User | Prestataire | null> {
    // Chercher d'abord dans la table prestataire
    let prestataire = await this.prestataireRepository.findOne({ where: { id } });
    if (prestataire) {
      const { password: _, ...prestataireWithoutPassword } = prestataire;
      return prestataireWithoutPassword as Prestataire;
    }

    // Sinon chercher dans la table user
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) return null;

    const { password: _, ...userWithoutPassword } = user;
    return userWithoutPassword as User;
  }

  async updateProfileImage(id: string, imageUrl: string): Promise<User | Prestataire | null> {
    console.log('=== UPDATE PROFILE IMAGE ===');
    console.log('ID utilisateur:', id);
    console.log('URL image:', imageUrl);
    
    // Chercher d'abord dans la table prestataire
    let prestataire = await this.prestataireRepository.findOne({ where: { id } });
    console.log('Prestataire trouvé:', !!prestataire);
    
    if (prestataire) {
      console.log('Ancienne image prestataire:', prestataire.profileImage);
      prestataire.profileImage = imageUrl;
      const updatedPrestataire = await this.prestataireRepository.save(prestataire);
      console.log('Nouvelle image prestataire:', updatedPrestataire.profileImage);
      const { password: _, ...prestataireWithoutPassword } = updatedPrestataire;
      return prestataireWithoutPassword as Prestataire;
    }

    // Sinon chercher dans la table user
    const user = await this.userRepository.findOne({ where: { id } });
    console.log('User trouvé:', !!user);
    
    if (!user) {
      console.log('Aucun utilisateur trouvé avec cet ID');
      return null;
    }

    console.log('Ancienne image user:', user.profileImage);
    user.profileImage = imageUrl;
    const updatedUser = await this.userRepository.save(user);
    console.log('Nouvelle image user:', updatedUser.profileImage);
    const { password: _, ...userWithoutPassword } = updatedUser;
    return userWithoutPassword as User;
  }

  async socialAuth(socialAuthDto: SocialAuthDto): Promise<SocialAuthResponseDto> {
    console.log('🔵 === DÉBUT SOCIAL AUTH ===');
    console.log('🔵 Données reçues:', JSON.stringify(socialAuthDto, null, 2));
    
    const { provider, providerId, email, firstName, lastName, phone, profileImage, role, firebaseUid, emailVerified } = socialAuthDto;

    // Vérifier si l'utilisateur existe déjà avec cet email
    console.log('🔵 Recherche d\'utilisateurs existants...');
    let existingUser = await this.userRepository.findOne({ where: { email } });
    let existingPrestataire = await this.prestataireRepository.findOne({ where: { email } });
    
    console.log('🔵 Utilisateur existant trouvé:', !!existingUser);
    console.log('🔵 Prestataire existant trouvé:', !!existingPrestataire);
    
    let user: User | Prestataire;

    if (existingUser) {
      // Mettre à jour les informations sociales si nécessaire
      if (!existingUser.isSocialAuth) {
        existingUser.isSocialAuth = true;
        existingUser[`${provider}Id`] = providerId;
        if (profileImage) existingUser.profileImage = profileImage;
        await this.userRepository.save(existingUser);
      }
      user = existingUser;
    } else if (existingPrestataire) {
      // Mettre à jour les informations sociales si nécessaire
      if (!existingPrestataire.isSocialAuth) {
        existingPrestataire.isSocialAuth = true;
        existingPrestataire[`${provider}Id`] = providerId;
        if (profileImage) existingPrestataire.profileImage = profileImage;
        await this.prestataireRepository.save(existingPrestataire);
      }
      user = existingPrestataire;
    } else {
      // L'utilisateur n'existe pas - créer un nouvel utilisateur
      console.log(`🔵 Création d'un nouvel utilisateur social: ${email} avec le rôle: ${role}`);
      
      if (role === 'prestataire') {
        // Créer un nouveau prestataire
        const newPrestataire = this.prestataireRepository.create({
          email,
          firstName,
          lastName,
          phone: phone || '',
          password: '', // Pas de mot de passe pour l'auth sociale
          role: UserRole.PRESTATAIRE,
          name: `${firstName} ${lastName}`,
          category: 'Général',
          location: 'Non spécifié',
          description: 'Prestataire de services',
          pricePerHour: 0,
          skills: [],
          categories: [],
          portfolio: [],
          profileImage,
          isSocialAuth: true,
          [`${provider}Id`]: providerId,
          firebaseUid: firebaseUid,
          isAvailable: true,
          rating: 0,
          reviewCount: 0,
          completedJobs: 0,
          totalReviews: 0,
        });

        user = await this.prestataireRepository.save(newPrestataire);
        console.log(`Nouveau prestataire créé: ${user.id}`);
      } else {
        // Créer un nouveau client
        const newUser = this.userRepository.create({
          email,
          firstName,
          lastName,
          phone: phone || '',
          password: '', // Pas de mot de passe pour l'auth sociale
          role: UserRole.CLIENT,
          isSocialAuth: true,
          [`${provider}Id`]: providerId,
          firebaseUid: firebaseUid,
          profileImage,
        });

        user = await this.userRepository.save(newUser);
        console.log(`Nouveau client créé: ${user.id}`);
      }
    }

    // Générer le token JWT
    console.log('🔵 Génération du token JWT...');
    const token = this.jwtService.sign({
      sub: user.id,
      email: user.email,
      role: user.role,
    });

    // Retourner la réponse
    console.log('🔵 Préparation de la réponse...');
    const { password: _, ...userWithoutPassword } = user;
    const response = {
      user: {
        id: userWithoutPassword.id,
        email: userWithoutPassword.email,
        firstName: userWithoutPassword.firstName,
        lastName: userWithoutPassword.lastName,
        phone: userWithoutPassword.phone,
        role: userWithoutPassword.role,
        profileImage: userWithoutPassword.profileImage,
        isSocialAuth: userWithoutPassword.isSocialAuth,
      },
      token,
    };
    
    console.log('✅ === FIN SOCIAL AUTH ===');
    console.log('✅ Réponse:', JSON.stringify(response, null, 2));
    return response;
  }
}
