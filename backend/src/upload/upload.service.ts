// backend/src/upload/upload.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as multer from 'multer';
import * as path from 'path';
import * as fs from 'fs';

@Injectable()
export class UploadService {
  private readonly uploadPath: string;

  constructor(private configService: ConfigService) {
    this.uploadPath = path.join(process.cwd(), 'uploads', 'profiles');
    this.ensureUploadDirectory();
  }

  private ensureUploadDirectory() {
    if (!fs.existsSync(this.uploadPath)) {
      fs.mkdirSync(this.uploadPath, { recursive: true });
    }
  }

  getMulterConfig() {
    return multer({
      storage: multer.diskStorage({
        destination: (req, file, cb) => {
          cb(null, this.uploadPath);
        },
        filename: (req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
          const ext = path.extname(file.originalname);
          cb(null, `profile-${uniqueSuffix}${ext}`);
        },
      }),
      fileFilter: (req, file, cb) => {
        if (file.mimetype.match(/\/(jpg|jpeg|png|gif)$/)) {
          cb(null, true);
        } else {
          cb(new Error('Seuls les fichiers JPG, JPEG, PNG et GIF sont autorisés'), false);
        }
      },
      limits: {
        fileSize: 5 * 1024 * 1024, // 5MB
      },
    });
  }

  getProfileImageUrl(filename: string): string {
    const baseUrl = this.configService.get('BASE_URL', 'http://192.168.1.73:3000');
    const imageUrl = `${baseUrl}/uploads/profiles/${filename}`;
    console.log('URL de l\'image générée:', imageUrl);
    return imageUrl;
  }

  deleteProfileImage(filename: string): boolean {
    try {
      const filePath = path.join(this.uploadPath, filename);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        return true;
      }
      return false;
    } catch (error) {
      console.error('Erreur lors de la suppression du fichier:', error);
      return false;
    }
  }
}
