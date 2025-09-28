import { Prestataire } from '../../entities/prestataire.entity';

export class PrestataireWithStatsDto extends Prestataire {
  declare rating: number;
  declare totalReviews: number;
  declare completedJobs: number;
}
