import { MigrationInterface, QueryRunner } from "typeorm";

export class AddSocialAuthFields1737634679000 implements MigrationInterface {
    name = 'AddSocialAuthFields1737634679000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Add social auth fields to users table
        await queryRunner.query(`ALTER TABLE \`users\` ADD \`googleId\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`users\` ADD \`facebookId\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`users\` ADD \`appleId\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`users\` ADD \`isSocialAuth\` tinyint NOT NULL DEFAULT 0`);
        await queryRunner.query(`ALTER TABLE \`users\` MODIFY \`password\` varchar(255) NULL`);

        // Add social auth fields to prestataires table
        await queryRunner.query(`ALTER TABLE \`prestataires\` ADD \`googleId\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`prestataires\` ADD \`facebookId\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`prestataires\` ADD \`appleId\` varchar(255) NULL`);
        await queryRunner.query(`ALTER TABLE \`prestataires\` ADD \`isSocialAuth\` tinyint NOT NULL DEFAULT 0`);
        await queryRunner.query(`ALTER TABLE \`prestataires\` MODIFY \`password\` varchar(255) NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Remove social auth fields from prestataires table
        await queryRunner.query(`ALTER TABLE \`prestataires\` MODIFY \`password\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`prestataires\` DROP COLUMN \`isSocialAuth\``);
        await queryRunner.query(`ALTER TABLE \`prestataires\` DROP COLUMN \`appleId\``);
        await queryRunner.query(`ALTER TABLE \`prestataires\` DROP COLUMN \`facebookId\``);
        await queryRunner.query(`ALTER TABLE \`prestataires\` DROP COLUMN \`googleId\``);

        // Remove social auth fields from users table
        await queryRunner.query(`ALTER TABLE \`users\` MODIFY \`password\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`users\` DROP COLUMN \`isSocialAuth\``);
        await queryRunner.query(`ALTER TABLE \`users\` DROP COLUMN \`appleId\``);
        await queryRunner.query(`ALTER TABLE \`users\` DROP COLUMN \`facebookId\``);
        await queryRunner.query(`ALTER TABLE \`users\` DROP COLUMN \`googleId\``);
    }
}



