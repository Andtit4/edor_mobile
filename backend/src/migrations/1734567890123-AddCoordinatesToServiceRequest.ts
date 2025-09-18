import { MigrationInterface, QueryRunner } from "typeorm";

export class AddCoordinatesToServiceRequest1734567890123 implements MigrationInterface {
    name = 'AddCoordinatesToServiceRequest1734567890123'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`service_requests\` ADD \`latitude\` decimal(10,8) NULL`);
        await queryRunner.query(`ALTER TABLE \`service_requests\` ADD \`longitude\` decimal(11,8) NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`service_requests\` DROP COLUMN \`longitude\``);
        await queryRunner.query(`ALTER TABLE \`service_requests\` DROP COLUMN \`latitude\``);
    }
}
