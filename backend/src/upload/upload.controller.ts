// backend/src/upload/upload.controller.ts
import {
  Controller,
  Post,
  Get,
  UseInterceptors,
  UploadedFile,
  UploadedFiles,
  UseGuards,
  Request,
  Param,
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { UploadService } from './upload.service';
import { AuthService } from '../auth/auth.service';
import * as multer from 'multer';

@Controller('upload')
@UseGuards(JwtAuthGuard)
export class UploadController {
  constructor(
    private readonly uploadService: UploadService,
    private readonly authService: AuthService,
  ) {}

  @Get('test-image/:filename')
  async testImage(@Param('filename') filename: string) {
    const fs = require('fs');
    const path = require('path');
    const uploadPath = path.join(process.cwd(), 'uploads', 'profiles');
    const filePath = path.join(uploadPath, filename);
    
    console.log('Test image - File path:', filePath);
    console.log('File exists:', fs.existsSync(filePath));
    
    if (fs.existsSync(filePath)) {
      return { 
        message: 'Image trouvée',
        filePath,
        url: `http://192.168.1.73:3000/uploads/profiles/${filename}`
      };
    } else {
      return { 
        message: 'Image non trouvée',
        filePath,
        filesInDir: fs.readdirSync(uploadPath)
      };
    }
  }

  @Get('check-user/:userId')
  @UseGuards(JwtAuthGuard)
  async checkUser(@Param('userId') userId: string) {
    console.log('=== CHECK USER ===');
    console.log('User ID:', userId);
    
    const user = await this.authService.findById(userId);
    console.log('User trouvé:', !!user);
    if (user) {
      console.log('User profileImage:', user.profileImage);
    }
    
    return {
      userId,
      userFound: !!user,
      profileImage: user?.profileImage || null
    };
  }

  @Post('profile-image')
  @UseInterceptors(FileInterceptor('image', {
    limits: {
      fileSize: 5 * 1024 * 1024, // 5MB
    },
    fileFilter: (req, file, cb) => {
      console.log('FileInterceptor - File:', {
        fieldname: file.fieldname,
        originalname: file.originalname,
        encoding: file.encoding,
        mimetype: file.mimetype
      });
      // Accepter tous les fichiers pour le débogage
      cb(null, true);
    }
  }))
  async uploadProfileImage(
    @UploadedFile() file: any,
    @Request() req: any,
  ) {
    console.log('Upload request received:', {
      hasFile: !!file,
      mimetype: file?.mimetype,
      originalname: file?.originalname,
      size: file?.size
    });

    if (!file) {
      throw new BadRequestException('Aucun fichier fourni');
    }

    // DÉBOGAGE: Accepter TOUS les fichiers pour identifier le problème
    console.log('=== UPLOAD DEBUG COMPLET ===');
    console.log('File mimetype:', file.mimetype);
    console.log('Original name:', file.originalname);
    console.log('File size:', file.size, 'bytes');
    console.log('File fieldname:', file.fieldname);
    console.log('File encoding:', file.encoding);
    console.log('File buffer length:', file.buffer?.length);
    console.log('File keys:', Object.keys(file));
    
    // Vérifier l'extension du fichier
    const fileExtension = file.originalname.toLowerCase().substring(file.originalname.lastIndexOf('.'));
    console.log('Extension détectée:', fileExtension);
    
    // Pour le moment, on accepte TOUS les fichiers pour voir ce qui se passe
    console.log('⚠️  MODE DÉBOGAGE: Validation de format désactivée');
    console.log('==================');

    // Validation de la taille (5MB)
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (file.size > maxSize) {
      throw new BadRequestException('Le fichier est trop volumineux (max 5MB)');
    }

    // Générer un nom de fichier unique
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const ext = file.originalname.split('.').pop();
    const filename = `profile-${uniqueSuffix}.${ext}`;

    try {
      const userId = req.user.id;
      console.log('=== UPLOAD DEBUG ===');
      console.log('User ID from token:', userId);
      console.log('User object from token:', req.user);
      
      const user = await this.authService.findById(userId);

      if (!user) {
        throw new BadRequestException('Utilisateur non trouvé');
      }

      // Supprimer l'ancienne image si elle existe
      if (user.profileImage) {
        const oldFilename = user.profileImage.split('/').pop();
        if (oldFilename) {
          this.uploadService.deleteProfileImage(oldFilename);
        }
      }
      
      // Sauvegarder le fichier
      const fs = require('fs');
      const path = require('path');
      const uploadPath = path.join(process.cwd(), 'uploads', 'profiles');
      
      // Créer le dossier s'il n'existe pas
      if (!fs.existsSync(uploadPath)) {
        fs.mkdirSync(uploadPath, { recursive: true });
      }
      
      const filePath = path.join(uploadPath, filename);
      fs.writeFileSync(filePath, file.buffer);

      // Générer l'URL de la nouvelle image
      const imageUrl = this.uploadService.getProfileImageUrl(filename);

      // Mettre à jour l'utilisateur avec la nouvelle URL
      console.log('Mise à jour de la base de données pour userId:', userId, 'imageUrl:', imageUrl);
      const updatedUser = await this.authService.updateProfileImage(userId, imageUrl);
      console.log('Utilisateur mis à jour:', updatedUser ? 'Succès' : 'Échec');

      return {
        message: 'Photo de profil mise à jour avec succès',
        imageUrl,
        filename: filename,
      };
    } catch (error) {
      // Supprimer le fichier en cas d'erreur
      if (file && filename) {
        this.uploadService.deleteProfileImage(filename);
      }
      throw new InternalServerErrorException('Erreur lors de l\'upload de l\'image');
    }
  }

  @Post('service-request-images')
  @UseInterceptors(FilesInterceptor('images', 10, {
    limits: {
      fileSize: 5 * 1024 * 1024, // 5MB per file
    },
    fileFilter: (req, file, cb) => {
      console.log('FilesInterceptor - File:', {
        fieldname: file.fieldname,
        originalname: file.originalname,
        mimetype: file.mimetype
      });
      
      // Validation des types de fichiers
      const allowedMimes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
      if (allowedMimes.includes(file.mimetype)) {
        cb(null, true);
      } else {
        cb(new BadRequestException('Seuls les fichiers JPG, JPEG, PNG et GIF sont autorisés'), false);
      }
    }
  }))
  async uploadServiceRequestImages(
    @UploadedFiles() files: any[],
    @Request() req: any,
  ) {
    console.log('Upload multiple images request received:', {
      filesCount: files?.length || 0,
      files: files?.map(f => ({
        originalname: f.originalname,
        mimetype: f.mimetype,
        size: f.size
      }))
    });

    if (!files || files.length === 0) {
      throw new BadRequestException('Aucun fichier fourni');
    }

    if (files.length > 10) {
      throw new BadRequestException('Maximum 10 images autorisées');
    }

    // Validation de la taille pour chaque fichier
    const maxSize = 5 * 1024 * 1024; // 5MB
    for (const file of files) {
      if (file.size > maxSize) {
        throw new BadRequestException(`Le fichier ${file.originalname} est trop volumineux (max 5MB)`);
      }
    }

    try {
      const userId = req.user.id;
      console.log('Upload service request images for user:', userId);

      const imageUrls: string[] = [];
      const fs = require('fs');
      const path = require('path');
      const uploadPath = path.join(process.cwd(), 'uploads', 'service-requests');
      
      // Créer le dossier s'il n'existe pas
      if (!fs.existsSync(uploadPath)) {
        fs.mkdirSync(uploadPath, { recursive: true });
      }

      // Traiter chaque fichier
      for (const file of files) {
        // Générer un nom de fichier unique
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = file.originalname.split('.').pop();
        const filename = `service-request-${uniqueSuffix}.${ext}`;
        
        // Sauvegarder le fichier
        const filePath = path.join(uploadPath, filename);
        fs.writeFileSync(filePath, file.buffer);
        
        // Générer l'URL
        const imageUrl = this.uploadService.getServiceRequestImageUrl(filename);
        imageUrls.push(imageUrl);
        
        console.log('Image sauvegardée:', filename, 'URL:', imageUrl);
      }

      return {
        message: 'Images uploadées avec succès',
        imageUrls,
        count: imageUrls.length,
      };
    } catch (error) {
      console.error('Erreur lors de l\'upload des images:', error);
      throw new InternalServerErrorException('Erreur lors de l\'upload des images');
    }
  }
}
