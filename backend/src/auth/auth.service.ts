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

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Prestataire)
    private prestataireRepository: Repository<Prestataire>,
    private jwtService: JwtService,
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
}
