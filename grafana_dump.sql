PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE `migration_log` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `migration_id` TEXT NOT NULL
, `sql` TEXT NOT NULL
, `success` INTEGER NOT NULL
, `error` TEXT NOT NULL
, `timestamp` DATETIME NOT NULL
);
INSERT INTO migration_log VALUES(1,'create migration_log table',replace('CREATE TABLE IF NOT EXISTS `migration_log` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `migration_id` TEXT NOT NULL\n, `sql` TEXT NOT NULL\n, `success` INTEGER NOT NULL\n, `error` TEXT NOT NULL\n, `timestamp` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(2,'create user table',replace('CREATE TABLE IF NOT EXISTS `user` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `version` INTEGER NOT NULL\n, `login` TEXT NOT NULL\n, `email` TEXT NOT NULL\n, `name` TEXT NULL\n, `password` TEXT NULL\n, `salt` TEXT NULL\n, `rands` TEXT NULL\n, `company` TEXT NULL\n, `account_id` INTEGER NOT NULL\n, `is_admin` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(3,'add unique index user.login','CREATE UNIQUE INDEX `UQE_user_login` ON `user` (`login`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(4,'add unique index user.email','CREATE UNIQUE INDEX `UQE_user_email` ON `user` (`email`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(5,'drop index UQE_user_login - v1','DROP INDEX `UQE_user_login`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(6,'drop index UQE_user_email - v1','DROP INDEX `UQE_user_email`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(7,'Rename table user to user_v1 - v1','ALTER TABLE `user` RENAME TO `user_v1`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(8,'create user table v2',replace('CREATE TABLE IF NOT EXISTS `user` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `version` INTEGER NOT NULL\n, `login` TEXT NOT NULL\n, `email` TEXT NOT NULL\n, `name` TEXT NULL\n, `password` TEXT NULL\n, `salt` TEXT NULL\n, `rands` TEXT NULL\n, `company` TEXT NULL\n, `org_id` INTEGER NOT NULL\n, `is_admin` INTEGER NOT NULL\n, `email_verified` INTEGER NULL\n, `theme` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(9,'create index UQE_user_login - v2','CREATE UNIQUE INDEX `UQE_user_login` ON `user` (`login`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(10,'create index UQE_user_email - v2','CREATE UNIQUE INDEX `UQE_user_email` ON `user` (`email`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(11,'copy data_source v1 to v2',replace('INSERT INTO `user` (`salt`\n, `org_id`\n, `id`\n, `email`\n, `name`\n, `password`\n, `is_admin`\n, `created`\n, `updated`\n, `version`\n, `login`\n, `rands`\n, `company`) SELECT `salt`\n, `account_id`\n, `id`\n, `email`\n, `name`\n, `password`\n, `is_admin`\n, `created`\n, `updated`\n, `version`\n, `login`\n, `rands`\n, `company` FROM `user_v1`','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(12,'Drop old table user_v1','DROP TABLE IF EXISTS `user_v1`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(13,'Add column help_flags1 to user table','alter table `user` ADD COLUMN `help_flags1` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(14,'Update user table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(15,'Add last_seen_at column to user','alter table `user` ADD COLUMN `last_seen_at` DATETIME NULL ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(16,'Add missing user data','code migration',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(17,'Add is_disabled column to user','alter table `user` ADD COLUMN `is_disabled` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(18,'Add index user.login/user.email','CREATE INDEX `IDX_user_login_email` ON `user` (`login`,`email`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(19,'Add is_service_account column to user','alter table `user` ADD COLUMN `is_service_account` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(20,'Update is_service_account column to nullable',replace('ALTER TABLE user ADD COLUMN tmp_service_account BOOLEAN DEFAULT 0;\nUPDATE user SET tmp_service_account = is_service_account;\nALTER TABLE user DROP COLUMN is_service_account;\nALTER TABLE user RENAME COLUMN tmp_service_account TO is_service_account;','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(21,'Add uid column to user','alter table `user` ADD COLUMN `uid` TEXT NULL ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(22,'Update uid column values for users','UPDATE user SET uid=printf(''u%09d'',id) WHERE uid IS NULL;',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(23,'Add unique index user_uid','CREATE UNIQUE INDEX `UQE_user_uid` ON `user` (`uid`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(24,'update login field with orgid to allow for multiple service accounts with same name across orgs','code migration',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(25,'update service accounts login field orgid to appear only once','code migration',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(26,'update login and email fields to lowercase','code migration',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(27,'update login and email fields to lowercase2','code migration',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(28,'create temp user table v1-7',replace('CREATE TABLE IF NOT EXISTS `temp_user` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `email` TEXT NOT NULL\n, `name` TEXT NULL\n, `role` TEXT NULL\n, `code` TEXT NOT NULL\n, `status` TEXT NOT NULL\n, `invited_by_user_id` INTEGER NULL\n, `email_sent` INTEGER NOT NULL\n, `email_sent_on` DATETIME NULL\n, `remote_addr` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(29,'create index IDX_temp_user_email - v1-7','CREATE INDEX `IDX_temp_user_email` ON `temp_user` (`email`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(30,'create index IDX_temp_user_org_id - v1-7','CREATE INDEX `IDX_temp_user_org_id` ON `temp_user` (`org_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(31,'create index IDX_temp_user_code - v1-7','CREATE INDEX `IDX_temp_user_code` ON `temp_user` (`code`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(32,'create index IDX_temp_user_status - v1-7','CREATE INDEX `IDX_temp_user_status` ON `temp_user` (`status`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(33,'Update temp_user table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(34,'drop index IDX_temp_user_email - v1','DROP INDEX `IDX_temp_user_email`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(35,'drop index IDX_temp_user_org_id - v1','DROP INDEX `IDX_temp_user_org_id`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(36,'drop index IDX_temp_user_code - v1','DROP INDEX `IDX_temp_user_code`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(37,'drop index IDX_temp_user_status - v1','DROP INDEX `IDX_temp_user_status`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(38,'Rename table temp_user to temp_user_tmp_qwerty - v1','ALTER TABLE `temp_user` RENAME TO `temp_user_tmp_qwerty`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(39,'create temp_user v2',replace('CREATE TABLE IF NOT EXISTS `temp_user` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `email` TEXT NOT NULL\n, `name` TEXT NULL\n, `role` TEXT NULL\n, `code` TEXT NOT NULL\n, `status` TEXT NOT NULL\n, `invited_by_user_id` INTEGER NULL\n, `email_sent` INTEGER NOT NULL\n, `email_sent_on` DATETIME NULL\n, `remote_addr` TEXT NULL\n, `created` INTEGER NOT NULL DEFAULT 0\n, `updated` INTEGER NOT NULL DEFAULT 0\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(40,'create index IDX_temp_user_email - v2','CREATE INDEX `IDX_temp_user_email` ON `temp_user` (`email`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(41,'create index IDX_temp_user_org_id - v2','CREATE INDEX `IDX_temp_user_org_id` ON `temp_user` (`org_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(42,'create index IDX_temp_user_code - v2','CREATE INDEX `IDX_temp_user_code` ON `temp_user` (`code`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(43,'create index IDX_temp_user_status - v2','CREATE INDEX `IDX_temp_user_status` ON `temp_user` (`status`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(44,'copy temp_user v1 to v2',replace('INSERT INTO `temp_user` (`email`\n, `invited_by_user_id`\n, `email_sent_on`\n, `version`\n, `org_id`\n, `name`\n, `role`\n, `code`\n, `status`\n, `email_sent`\n, `remote_addr`\n, `id`) SELECT `email`\n, `invited_by_user_id`\n, `email_sent_on`\n, `version`\n, `org_id`\n, `name`\n, `role`\n, `code`\n, `status`\n, `email_sent`\n, `remote_addr`\n, `id` FROM `temp_user_tmp_qwerty`','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(45,'drop temp_user_tmp_qwerty','DROP TABLE IF EXISTS `temp_user_tmp_qwerty`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(46,'Set created for temp users that will otherwise prematurely expire','code migration',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(47,'create star table',replace('CREATE TABLE IF NOT EXISTS `star` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `user_id` INTEGER NOT NULL\n, `dashboard_id` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(48,'add unique index star.user_id_dashboard_id','CREATE UNIQUE INDEX `UQE_star_user_id_dashboard_id` ON `star` (`user_id`,`dashboard_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(49,'Add column dashboard_uid in star','alter table `star` ADD COLUMN `dashboard_uid` TEXT NULL ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(50,'Add column org_id in star','alter table `star` ADD COLUMN `org_id` INTEGER NULL DEFAULT 1 ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(51,'Add column updated in star','alter table `star` ADD COLUMN `updated` DATETIME NULL ',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(52,'add index in star table on dashboard_uid, org_id and user_id columns','CREATE UNIQUE INDEX `UQE_star_user_id_dashboard_uid_org_id` ON `star` (`user_id`,`dashboard_uid`,`org_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(53,'create org table v1',replace('CREATE TABLE IF NOT EXISTS `org` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `version` INTEGER NOT NULL\n, `name` TEXT NOT NULL\n, `address1` TEXT NULL\n, `address2` TEXT NULL\n, `city` TEXT NULL\n, `state` TEXT NULL\n, `zip_code` TEXT NULL\n, `country` TEXT NULL\n, `billing_email` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(54,'create index UQE_org_name - v1','CREATE UNIQUE INDEX `UQE_org_name` ON `org` (`name`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(55,'create org_user table v1',replace('CREATE TABLE IF NOT EXISTS `org_user` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `user_id` INTEGER NOT NULL\n, `role` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(56,'create index IDX_org_user_org_id - v1','CREATE INDEX `IDX_org_user_org_id` ON `org_user` (`org_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(57,'create index UQE_org_user_org_id_user_id - v1','CREATE UNIQUE INDEX `UQE_org_user_org_id_user_id` ON `org_user` (`org_id`,`user_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(58,'create index IDX_org_user_user_id - v1','CREATE INDEX `IDX_org_user_user_id` ON `org_user` (`user_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(59,'Update org table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(60,'Update org_user table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(61,'Migrate all Read Only Viewers to Viewers','UPDATE org_user SET role = ''Viewer'' WHERE role = ''Read Only Editor''',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(62,'create dashboard table',replace('CREATE TABLE IF NOT EXISTS `dashboard` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `version` INTEGER NOT NULL\n, `slug` TEXT NOT NULL\n, `title` TEXT NOT NULL\n, `data` TEXT NOT NULL\n, `account_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(63,'add index dashboard.account_id','CREATE INDEX `IDX_dashboard_account_id` ON `dashboard` (`account_id`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(64,'add unique index dashboard_account_id_slug','CREATE UNIQUE INDEX `UQE_dashboard_account_id_slug` ON `dashboard` (`account_id`,`slug`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(65,'create dashboard_tag table',replace('CREATE TABLE IF NOT EXISTS `dashboard_tag` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `dashboard_id` INTEGER NOT NULL\n, `term` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(66,'add unique index dashboard_tag.dasboard_id_term','CREATE UNIQUE INDEX `UQE_dashboard_tag_dashboard_id_term` ON `dashboard_tag` (`dashboard_id`,`term`);',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(67,'drop index UQE_dashboard_tag_dashboard_id_term - v1','DROP INDEX `UQE_dashboard_tag_dashboard_id_term`',1,'','2025-05-23 21:43:10');
INSERT INTO migration_log VALUES(68,'Rename table dashboard to dashboard_v1 - v1','ALTER TABLE `dashboard` RENAME TO `dashboard_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(69,'create dashboard v2',replace('CREATE TABLE IF NOT EXISTS `dashboard` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `version` INTEGER NOT NULL\n, `slug` TEXT NOT NULL\n, `title` TEXT NOT NULL\n, `data` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(70,'create index IDX_dashboard_org_id - v2','CREATE INDEX `IDX_dashboard_org_id` ON `dashboard` (`org_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(71,'create index UQE_dashboard_org_id_slug - v2','CREATE UNIQUE INDEX `UQE_dashboard_org_id_slug` ON `dashboard` (`org_id`,`slug`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(72,'copy dashboard v1 to v2',replace('INSERT INTO `dashboard` (`updated`\n, `id`\n, `version`\n, `slug`\n, `title`\n, `data`\n, `org_id`\n, `created`) SELECT `updated`\n, `id`\n, `version`\n, `slug`\n, `title`\n, `data`\n, `account_id`\n, `created` FROM `dashboard_v1`','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(73,'drop table dashboard_v1','DROP TABLE IF EXISTS `dashboard_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(74,'alter dashboard.data to mediumtext v1','SELECT 0;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(75,'Add column updated_by in dashboard - v2','alter table `dashboard` ADD COLUMN `updated_by` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(76,'Add column created_by in dashboard - v2','alter table `dashboard` ADD COLUMN `created_by` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(77,'Add column gnetId in dashboard','alter table `dashboard` ADD COLUMN `gnet_id` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(78,'Add index for gnetId in dashboard','CREATE INDEX `IDX_dashboard_gnet_id` ON `dashboard` (`gnet_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(79,'Add column plugin_id in dashboard','alter table `dashboard` ADD COLUMN `plugin_id` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(80,'Add index for plugin_id in dashboard','CREATE INDEX `IDX_dashboard_org_id_plugin_id` ON `dashboard` (`org_id`,`plugin_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(81,'Add index for dashboard_id in dashboard_tag','CREATE INDEX `IDX_dashboard_tag_dashboard_id` ON `dashboard_tag` (`dashboard_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(82,'Update dashboard table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(83,'Update dashboard_tag table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(84,'Add column folder_id in dashboard','alter table `dashboard` ADD COLUMN `folder_id` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(85,'Add column isFolder in dashboard','alter table `dashboard` ADD COLUMN `is_folder` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(86,'Add column has_acl in dashboard','alter table `dashboard` ADD COLUMN `has_acl` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(87,'Add column uid in dashboard','alter table `dashboard` ADD COLUMN `uid` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(88,'Update uid column values in dashboard','UPDATE dashboard SET uid=printf(''%09d'',id) WHERE uid IS NULL;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(89,'Add unique index dashboard_org_id_uid','CREATE UNIQUE INDEX `UQE_dashboard_org_id_uid` ON `dashboard` (`org_id`,`uid`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(90,'Remove unique index org_id_slug','DROP INDEX `UQE_dashboard_org_id_slug`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(91,'Update dashboard title length','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(92,'Add unique index for dashboard_org_id_title_folder_id','CREATE UNIQUE INDEX `UQE_dashboard_org_id_folder_id_title` ON `dashboard` (`org_id`,`folder_id`,`title`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(93,'create dashboard_provisioning',replace('CREATE TABLE IF NOT EXISTS `dashboard_provisioning` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `dashboard_id` INTEGER NULL\n, `name` TEXT NOT NULL\n, `external_id` TEXT NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(94,'Rename table dashboard_provisioning to dashboard_provisioning_tmp_qwerty - v1','ALTER TABLE `dashboard_provisioning` RENAME TO `dashboard_provisioning_tmp_qwerty`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(95,'create dashboard_provisioning v2',replace('CREATE TABLE IF NOT EXISTS `dashboard_provisioning` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `dashboard_id` INTEGER NULL\n, `name` TEXT NOT NULL\n, `external_id` TEXT NOT NULL\n, `updated` INTEGER NOT NULL DEFAULT 0\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(96,'create index IDX_dashboard_provisioning_dashboard_id - v2','CREATE INDEX `IDX_dashboard_provisioning_dashboard_id` ON `dashboard_provisioning` (`dashboard_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(97,'create index IDX_dashboard_provisioning_dashboard_id_name - v2','CREATE INDEX `IDX_dashboard_provisioning_dashboard_id_name` ON `dashboard_provisioning` (`dashboard_id`,`name`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(98,'copy dashboard_provisioning v1 to v2',replace('INSERT INTO `dashboard_provisioning` (`id`\n, `dashboard_id`\n, `name`\n, `external_id`) SELECT `id`\n, `dashboard_id`\n, `name`\n, `external_id` FROM `dashboard_provisioning_tmp_qwerty`','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(99,'drop dashboard_provisioning_tmp_qwerty','DROP TABLE IF EXISTS `dashboard_provisioning_tmp_qwerty`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(100,'Add check_sum column','alter table `dashboard_provisioning` ADD COLUMN `check_sum` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(101,'Add index for dashboard_title','CREATE INDEX `IDX_dashboard_title` ON `dashboard` (`title`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(102,'delete tags for deleted dashboards','DELETE FROM dashboard_tag WHERE dashboard_id NOT IN (SELECT id FROM dashboard)',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(103,'delete stars for deleted dashboards','DELETE FROM star WHERE dashboard_id NOT IN (SELECT id FROM dashboard)',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(104,'Add index for dashboard_is_folder','CREATE INDEX `IDX_dashboard_is_folder` ON `dashboard` (`is_folder`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(105,'Add isPublic for dashboard','alter table `dashboard` ADD COLUMN `is_public` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(106,'Add deleted for dashboard','alter table `dashboard` ADD COLUMN `deleted` DATETIME NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(107,'Add index for deleted','CREATE INDEX `IDX_dashboard_deleted` ON `dashboard` (`deleted`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(108,'Add column dashboard_uid in dashboard_tag','alter table `dashboard_tag` ADD COLUMN `dashboard_uid` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(109,'Add column org_id in dashboard_tag','alter table `dashboard_tag` ADD COLUMN `org_id` INTEGER NULL DEFAULT 1 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(110,'Add missing dashboard_uid and org_id to dashboard_tag','code migration',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(111,'Add missing dashboard_uid and org_id to star','code migration',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(112,'create data_source table',replace('CREATE TABLE IF NOT EXISTS `data_source` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `account_id` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `type` TEXT NOT NULL\n, `name` TEXT NOT NULL\n, `access` TEXT NOT NULL\n, `url` TEXT NOT NULL\n, `password` TEXT NULL\n, `user` TEXT NULL\n, `database` TEXT NULL\n, `basic_auth` INTEGER NOT NULL\n, `basic_auth_user` TEXT NULL\n, `basic_auth_password` TEXT NULL\n, `is_default` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(113,'add index data_source.account_id','CREATE INDEX `IDX_data_source_account_id` ON `data_source` (`account_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(114,'add unique index data_source.account_id_name','CREATE UNIQUE INDEX `UQE_data_source_account_id_name` ON `data_source` (`account_id`,`name`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(115,'drop index IDX_data_source_account_id - v1','DROP INDEX `IDX_data_source_account_id`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(116,'drop index UQE_data_source_account_id_name - v1','DROP INDEX `UQE_data_source_account_id_name`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(117,'Rename table data_source to data_source_v1 - v1','ALTER TABLE `data_source` RENAME TO `data_source_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(118,'create data_source table v2',replace('CREATE TABLE IF NOT EXISTS `data_source` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `type` TEXT NOT NULL\n, `name` TEXT NOT NULL\n, `access` TEXT NOT NULL\n, `url` TEXT NOT NULL\n, `password` TEXT NULL\n, `user` TEXT NULL\n, `database` TEXT NULL\n, `basic_auth` INTEGER NOT NULL\n, `basic_auth_user` TEXT NULL\n, `basic_auth_password` TEXT NULL\n, `is_default` INTEGER NOT NULL\n, `json_data` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(119,'create index IDX_data_source_org_id - v2','CREATE INDEX `IDX_data_source_org_id` ON `data_source` (`org_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(120,'create index UQE_data_source_org_id_name - v2','CREATE UNIQUE INDEX `UQE_data_source_org_id_name` ON `data_source` (`org_id`,`name`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(121,'Drop old table data_source_v1 #2','DROP TABLE IF EXISTS `data_source_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(122,'Add column with_credentials','alter table `data_source` ADD COLUMN `with_credentials` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(123,'Add secure json data column','alter table `data_source` ADD COLUMN `secure_json_data` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(124,'Update data_source table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(125,'Update initial version to 1','UPDATE data_source SET version = 1 WHERE version = 0',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(126,'Add read_only data column','alter table `data_source` ADD COLUMN `read_only` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(127,'Migrate logging ds to loki ds','UPDATE data_source SET type = ''loki'' WHERE type = ''logging''',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(128,'Update json_data with nulls','UPDATE data_source SET json_data = ''{}'' WHERE json_data is null',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(129,'Add uid column','alter table `data_source` ADD COLUMN `uid` TEXT NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(130,'Update uid value','UPDATE data_source SET uid=printf(''%09d'',id);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(131,'Add unique index datasource_org_id_uid','CREATE UNIQUE INDEX `UQE_data_source_org_id_uid` ON `data_source` (`org_id`,`uid`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(132,'add unique index datasource_org_id_is_default','CREATE INDEX `IDX_data_source_org_id_is_default` ON `data_source` (`org_id`,`is_default`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(133,'Add is_prunable column','alter table `data_source` ADD COLUMN `is_prunable` INTEGER NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(134,'Add api_version column','alter table `data_source` ADD COLUMN `api_version` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(135,'create api_key table',replace('CREATE TABLE IF NOT EXISTS `api_key` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `account_id` INTEGER NOT NULL\n, `name` TEXT NOT NULL\n, `key` TEXT NOT NULL\n, `role` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(136,'add index api_key.account_id','CREATE INDEX `IDX_api_key_account_id` ON `api_key` (`account_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(137,'add index api_key.key','CREATE UNIQUE INDEX `UQE_api_key_key` ON `api_key` (`key`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(138,'add index api_key.account_id_name','CREATE UNIQUE INDEX `UQE_api_key_account_id_name` ON `api_key` (`account_id`,`name`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(139,'drop index IDX_api_key_account_id - v1','DROP INDEX `IDX_api_key_account_id`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(140,'drop index UQE_api_key_key - v1','DROP INDEX `UQE_api_key_key`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(141,'drop index UQE_api_key_account_id_name - v1','DROP INDEX `UQE_api_key_account_id_name`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(142,'Rename table api_key to api_key_v1 - v1','ALTER TABLE `api_key` RENAME TO `api_key_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(143,'create api_key table v2',replace('CREATE TABLE IF NOT EXISTS `api_key` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `name` TEXT NOT NULL\n, `key` TEXT NOT NULL\n, `role` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(144,'create index IDX_api_key_org_id - v2','CREATE INDEX `IDX_api_key_org_id` ON `api_key` (`org_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(145,'create index UQE_api_key_key - v2','CREATE UNIQUE INDEX `UQE_api_key_key` ON `api_key` (`key`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(146,'create index UQE_api_key_org_id_name - v2','CREATE UNIQUE INDEX `UQE_api_key_org_id_name` ON `api_key` (`org_id`,`name`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(147,'copy api_key v1 to v2',replace('INSERT INTO `api_key` (`id`\n, `org_id`\n, `name`\n, `key`\n, `role`\n, `created`\n, `updated`) SELECT `id`\n, `account_id`\n, `name`\n, `key`\n, `role`\n, `created`\n, `updated` FROM `api_key_v1`','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(148,'Drop old table api_key_v1','DROP TABLE IF EXISTS `api_key_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(149,'Update api_key table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(150,'Add expires to api_key table','alter table `api_key` ADD COLUMN `expires` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(151,'Add service account foreign key','alter table `api_key` ADD COLUMN `service_account_id` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(152,'set service account foreign key to nil if 0','UPDATE api_key SET service_account_id = NULL WHERE service_account_id = 0;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(153,'Add last_used_at to api_key table','alter table `api_key` ADD COLUMN `last_used_at` DATETIME NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(154,'Add is_revoked column to api_key table','alter table `api_key` ADD COLUMN `is_revoked` INTEGER NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(155,'create dashboard_snapshot table v4',replace('CREATE TABLE IF NOT EXISTS `dashboard_snapshot` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `name` TEXT NOT NULL\n, `key` TEXT NOT NULL\n, `dashboard` TEXT NOT NULL\n, `expires` DATETIME NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(156,'drop table dashboard_snapshot_v4 #1','DROP TABLE IF EXISTS `dashboard_snapshot`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(157,'create dashboard_snapshot table v5 #2',replace('CREATE TABLE IF NOT EXISTS `dashboard_snapshot` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `name` TEXT NOT NULL\n, `key` TEXT NOT NULL\n, `delete_key` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `user_id` INTEGER NOT NULL\n, `external` INTEGER NOT NULL\n, `external_url` TEXT NOT NULL\n, `dashboard` TEXT NOT NULL\n, `expires` DATETIME NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(158,'create index UQE_dashboard_snapshot_key - v5','CREATE UNIQUE INDEX `UQE_dashboard_snapshot_key` ON `dashboard_snapshot` (`key`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(159,'create index UQE_dashboard_snapshot_delete_key - v5','CREATE UNIQUE INDEX `UQE_dashboard_snapshot_delete_key` ON `dashboard_snapshot` (`delete_key`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(160,'create index IDX_dashboard_snapshot_user_id - v5','CREATE INDEX `IDX_dashboard_snapshot_user_id` ON `dashboard_snapshot` (`user_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(161,'alter dashboard_snapshot to mediumtext v2','SELECT 0;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(162,'Update dashboard_snapshot table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(163,'Add column external_delete_url to dashboard_snapshots table','alter table `dashboard_snapshot` ADD COLUMN `external_delete_url` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(164,'Add encrypted dashboard json column','alter table `dashboard_snapshot` ADD COLUMN `dashboard_encrypted` BLOB NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(165,'Change dashboard_encrypted column to MEDIUMBLOB','SELECT 0;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(166,'create quota table v1',replace('CREATE TABLE IF NOT EXISTS `quota` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NULL\n, `user_id` INTEGER NULL\n, `target` TEXT NOT NULL\n, `limit` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(167,'create index UQE_quota_org_id_user_id_target - v1','CREATE UNIQUE INDEX `UQE_quota_org_id_user_id_target` ON `quota` (`org_id`,`user_id`,`target`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(168,'Update quota table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(169,'create plugin_setting table',replace('CREATE TABLE IF NOT EXISTS `plugin_setting` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NULL\n, `plugin_id` TEXT NOT NULL\n, `enabled` INTEGER NOT NULL\n, `pinned` INTEGER NOT NULL\n, `json_data` TEXT NULL\n, `secure_json_data` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(170,'create index UQE_plugin_setting_org_id_plugin_id - v1','CREATE UNIQUE INDEX `UQE_plugin_setting_org_id_plugin_id` ON `plugin_setting` (`org_id`,`plugin_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(171,'Add column plugin_version to plugin_settings','alter table `plugin_setting` ADD COLUMN `plugin_version` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(172,'Update plugin_setting table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(173,'update NULL org_id to 1','UPDATE plugin_setting SET org_id=1 where org_id IS NULL;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(174,'make org_id NOT NULL and DEFAULT VALUE 1',replace('\n			CREATE TABLE "plugin_setting_new" (\n			"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,\n			"org_id" INTEGER NOT NULL DEFAULT 1,\n			"plugin_id" TEXT NOT NULL,\n			"enabled" INTEGER NOT NULL,\n			"pinned" INTEGER NOT NULL,\n			"json_data" TEXT NULL,\n			"secure_json_data" TEXT NULL,\n			"created" DATETIME NOT NULL,\n			"updated" DATETIME NOT NULL,\n			"plugin_version" TEXT NULL);\n			INSERT INTO "plugin_setting_new" SELECT\n				"id",\n				COALESCE("org_id", 1),\n				"plugin_id",\n				"enabled",\n				"pinned",\n				"json_data",\n				"secure_json_data",\n				"created",\n				"updated",\n				"plugin_version"\n			FROM "plugin_setting";\n			DROP TABLE "plugin_setting";\n			ALTER TABLE "plugin_setting_new" RENAME TO "plugin_setting";\n			CREATE UNIQUE INDEX "UQE_plugin_setting_org_id_plugin_id" ON "plugin_setting" ("org_id","plugin_id");\n		','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(175,'create session table',replace('CREATE TABLE IF NOT EXISTS `session` (\n`key` TEXT PRIMARY KEY NOT NULL\n, `data` BLOB NOT NULL\n, `expiry` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(176,'Drop old table playlist table','DROP TABLE IF EXISTS `playlist`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(177,'Drop old table playlist_item table','DROP TABLE IF EXISTS `playlist_item`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(178,'create playlist table v2',replace('CREATE TABLE IF NOT EXISTS `playlist` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `name` TEXT NOT NULL\n, `interval` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(179,'create playlist item table v2',replace('CREATE TABLE IF NOT EXISTS `playlist_item` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `playlist_id` INTEGER NOT NULL\n, `type` TEXT NOT NULL\n, `value` TEXT NOT NULL\n, `title` TEXT NOT NULL\n, `order` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(180,'Update playlist table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(181,'Update playlist_item table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(182,'Add playlist column created_at','alter table `playlist` ADD COLUMN `created_at` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(183,'Add playlist column updated_at','alter table `playlist` ADD COLUMN `updated_at` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(184,'drop preferences table v2','DROP TABLE IF EXISTS `preferences`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(185,'drop preferences table v3','DROP TABLE IF EXISTS `preferences`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(186,'create preferences table v3',replace('CREATE TABLE IF NOT EXISTS `preferences` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `user_id` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `home_dashboard_id` INTEGER NOT NULL\n, `timezone` TEXT NOT NULL\n, `theme` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(187,'Update preferences table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(188,'Add column team_id in preferences','alter table `preferences` ADD COLUMN `team_id` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(189,'Update team_id column values in preferences','UPDATE preferences SET team_id=0 WHERE team_id IS NULL;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(190,'Add column week_start in preferences','alter table `preferences` ADD COLUMN `week_start` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(191,'Add column preferences.json_data','alter table `preferences` ADD COLUMN `json_data` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(192,'alter preferences.json_data to mediumtext v1','SELECT 0;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(193,'Add preferences index org_id','CREATE INDEX `IDX_preferences_org_id` ON `preferences` (`org_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(194,'Add preferences index user_id','CREATE INDEX `IDX_preferences_user_id` ON `preferences` (`user_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(195,'create alert table v1',replace('CREATE TABLE IF NOT EXISTS `alert` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `version` INTEGER NOT NULL\n, `dashboard_id` INTEGER NOT NULL\n, `panel_id` INTEGER NOT NULL\n, `org_id` INTEGER NOT NULL\n, `name` TEXT NOT NULL\n, `message` TEXT NOT NULL\n, `state` TEXT NOT NULL\n, `settings` TEXT NOT NULL\n, `frequency` INTEGER NOT NULL\n, `handler` INTEGER NOT NULL\n, `severity` TEXT NOT NULL\n, `silenced` INTEGER NOT NULL\n, `execution_error` TEXT NOT NULL\n, `eval_data` TEXT NULL\n, `eval_date` DATETIME NULL\n, `new_state_date` DATETIME NOT NULL\n, `state_changes` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(196,'add index alert org_id & id ','CREATE INDEX `IDX_alert_org_id_id` ON `alert` (`org_id`,`id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(197,'add index alert state','CREATE INDEX `IDX_alert_state` ON `alert` (`state`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(198,'add index alert dashboard_id','CREATE INDEX `IDX_alert_dashboard_id` ON `alert` (`dashboard_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(199,'Create alert_rule_tag table v1',replace('CREATE TABLE IF NOT EXISTS `alert_rule_tag` (\n`alert_id` INTEGER NOT NULL\n, `tag_id` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(200,'Add unique index alert_rule_tag.alert_id_tag_id','CREATE UNIQUE INDEX `UQE_alert_rule_tag_alert_id_tag_id` ON `alert_rule_tag` (`alert_id`,`tag_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(201,'drop index UQE_alert_rule_tag_alert_id_tag_id - v1','DROP INDEX `UQE_alert_rule_tag_alert_id_tag_id`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(202,'Rename table alert_rule_tag to alert_rule_tag_v1 - v1','ALTER TABLE `alert_rule_tag` RENAME TO `alert_rule_tag_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(203,'Create alert_rule_tag table v2',replace('CREATE TABLE IF NOT EXISTS `alert_rule_tag` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `alert_id` INTEGER NOT NULL\n, `tag_id` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(204,'create index UQE_alert_rule_tag_alert_id_tag_id - Add unique index alert_rule_tag.alert_id_tag_id V2','CREATE UNIQUE INDEX `UQE_alert_rule_tag_alert_id_tag_id` ON `alert_rule_tag` (`alert_id`,`tag_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(205,'copy alert_rule_tag v1 to v2',replace('INSERT INTO `alert_rule_tag` (`alert_id`\n, `tag_id`) SELECT `alert_id`\n, `tag_id` FROM `alert_rule_tag_v1`','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(206,'drop table alert_rule_tag_v1','DROP TABLE IF EXISTS `alert_rule_tag_v1`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(207,'create alert_notification table v1',replace('CREATE TABLE IF NOT EXISTS `alert_notification` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `name` TEXT NOT NULL\n, `type` TEXT NOT NULL\n, `settings` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(208,'Add column is_default','alter table `alert_notification` ADD COLUMN `is_default` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(209,'Add column frequency','alter table `alert_notification` ADD COLUMN `frequency` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(210,'Add column send_reminder','alter table `alert_notification` ADD COLUMN `send_reminder` INTEGER NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(211,'Add column disable_resolve_message','alter table `alert_notification` ADD COLUMN `disable_resolve_message` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(212,'add index alert_notification org_id & name','CREATE UNIQUE INDEX `UQE_alert_notification_org_id_name` ON `alert_notification` (`org_id`,`name`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(213,'Update alert table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(214,'Update alert_notification table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(215,'create notification_journal table v1',replace('CREATE TABLE IF NOT EXISTS `alert_notification_journal` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `alert_id` INTEGER NOT NULL\n, `notifier_id` INTEGER NOT NULL\n, `sent_at` INTEGER NOT NULL\n, `success` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(216,'add index notification_journal org_id & alert_id & notifier_id','CREATE INDEX `IDX_alert_notification_journal_org_id_alert_id_notifier_id` ON `alert_notification_journal` (`org_id`,`alert_id`,`notifier_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(217,'drop alert_notification_journal','DROP TABLE IF EXISTS `alert_notification_journal`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(218,'create alert_notification_state table v1',replace('CREATE TABLE IF NOT EXISTS `alert_notification_state` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `alert_id` INTEGER NOT NULL\n, `notifier_id` INTEGER NOT NULL\n, `state` TEXT NOT NULL\n, `version` INTEGER NOT NULL\n, `updated_at` INTEGER NOT NULL\n, `alert_rule_state_updated_version` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(219,'add index alert_notification_state org_id & alert_id & notifier_id','CREATE UNIQUE INDEX `UQE_alert_notification_state_org_id_alert_id_notifier_id` ON `alert_notification_state` (`org_id`,`alert_id`,`notifier_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(220,'Add for to alert table','alter table `alert` ADD COLUMN `for` INTEGER NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(221,'Add column uid in alert_notification','alter table `alert_notification` ADD COLUMN `uid` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(222,'Update uid column values in alert_notification','UPDATE alert_notification SET uid=printf(''%09d'',id) WHERE uid IS NULL;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(223,'Add unique index alert_notification_org_id_uid','CREATE UNIQUE INDEX `UQE_alert_notification_org_id_uid` ON `alert_notification` (`org_id`,`uid`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(224,'Remove unique index org_id_name','DROP INDEX `UQE_alert_notification_org_id_name`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(225,'Add column secure_settings in alert_notification','alter table `alert_notification` ADD COLUMN `secure_settings` TEXT NULL ',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(226,'alter alert.settings to mediumtext','SELECT 0;',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(227,'Add non-unique index alert_notification_state_alert_id','CREATE INDEX `IDX_alert_notification_state_alert_id` ON `alert_notification_state` (`alert_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(228,'Add non-unique index alert_rule_tag_alert_id','CREATE INDEX `IDX_alert_rule_tag_alert_id` ON `alert_rule_tag` (`alert_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(229,'Drop old annotation table v4','DROP TABLE IF EXISTS `annotation`',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(230,'create annotation table v5',replace('CREATE TABLE IF NOT EXISTS `annotation` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `alert_id` INTEGER NULL\n, `user_id` INTEGER NULL\n, `dashboard_id` INTEGER NULL\n, `panel_id` INTEGER NULL\n, `category_id` INTEGER NULL\n, `type` TEXT NOT NULL\n, `title` TEXT NOT NULL\n, `text` TEXT NOT NULL\n, `metric` TEXT NULL\n, `prev_state` TEXT NOT NULL\n, `new_state` TEXT NOT NULL\n, `data` TEXT NOT NULL\n, `epoch` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(231,'add index annotation 0 v3','CREATE INDEX `IDX_annotation_org_id_alert_id` ON `annotation` (`org_id`,`alert_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(232,'add index annotation 1 v3','CREATE INDEX `IDX_annotation_org_id_type` ON `annotation` (`org_id`,`type`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(233,'add index annotation 2 v3','CREATE INDEX `IDX_annotation_org_id_category_id` ON `annotation` (`org_id`,`category_id`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(234,'add index annotation 3 v3','CREATE INDEX `IDX_annotation_org_id_dashboard_id_panel_id_epoch` ON `annotation` (`org_id`,`dashboard_id`,`panel_id`,`epoch`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(235,'add index annotation 4 v3','CREATE INDEX `IDX_annotation_org_id_epoch` ON `annotation` (`org_id`,`epoch`);',1,'','2025-05-23 21:43:11');
INSERT INTO migration_log VALUES(236,'Update annotation table charset','-- NOT REQUIRED',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(237,'Add column region_id to annotation table','alter table `annotation` ADD COLUMN `region_id` INTEGER NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(238,'Drop category_id index','DROP INDEX `IDX_annotation_org_id_category_id`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(239,'Add column tags to annotation table','alter table `annotation` ADD COLUMN `tags` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(240,'Create annotation_tag table v2',replace('CREATE TABLE IF NOT EXISTS `annotation_tag` (\n`annotation_id` INTEGER NOT NULL\n, `tag_id` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(241,'Add unique index annotation_tag.annotation_id_tag_id','CREATE UNIQUE INDEX `UQE_annotation_tag_annotation_id_tag_id` ON `annotation_tag` (`annotation_id`,`tag_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(242,'drop index UQE_annotation_tag_annotation_id_tag_id - v2','DROP INDEX `UQE_annotation_tag_annotation_id_tag_id`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(243,'Rename table annotation_tag to annotation_tag_v2 - v2','ALTER TABLE `annotation_tag` RENAME TO `annotation_tag_v2`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(244,'Create annotation_tag table v3',replace('CREATE TABLE IF NOT EXISTS `annotation_tag` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `annotation_id` INTEGER NOT NULL\n, `tag_id` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(245,'create index UQE_annotation_tag_annotation_id_tag_id - Add unique index annotation_tag.annotation_id_tag_id V3','CREATE UNIQUE INDEX `UQE_annotation_tag_annotation_id_tag_id` ON `annotation_tag` (`annotation_id`,`tag_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(246,'copy annotation_tag v2 to v3',replace('INSERT INTO `annotation_tag` (`annotation_id`\n, `tag_id`) SELECT `annotation_id`\n, `tag_id` FROM `annotation_tag_v2`','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(247,'drop table annotation_tag_v2','DROP TABLE IF EXISTS `annotation_tag_v2`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(248,'Update alert annotations and set TEXT to empty','UPDATE annotation SET TEXT = '''' WHERE alert_id > 0',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(249,'Add created time to annotation table','alter table `annotation` ADD COLUMN `created` INTEGER NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(250,'Add updated time to annotation table','alter table `annotation` ADD COLUMN `updated` INTEGER NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(251,'Add index for created in annotation table','CREATE INDEX `IDX_annotation_org_id_created` ON `annotation` (`org_id`,`created`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(252,'Add index for updated in annotation table','CREATE INDEX `IDX_annotation_org_id_updated` ON `annotation` (`org_id`,`updated`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(253,'Convert existing annotations from seconds to milliseconds','UPDATE annotation SET epoch = (epoch*1000) where epoch < 9999999999',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(254,'Add epoch_end column','alter table `annotation` ADD COLUMN `epoch_end` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(255,'Add index for epoch_end','CREATE INDEX `IDX_annotation_org_id_epoch_epoch_end` ON `annotation` (`org_id`,`epoch`,`epoch_end`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(256,'Make epoch_end the same as epoch','UPDATE annotation SET epoch_end = epoch',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(257,'Move region to single row','code migration',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(258,'Remove index org_id_epoch from annotation table','DROP INDEX `IDX_annotation_org_id_epoch`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(259,'Remove index org_id_dashboard_id_panel_id_epoch from annotation table','DROP INDEX `IDX_annotation_org_id_dashboard_id_panel_id_epoch`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(260,'Add index for org_id_dashboard_id_epoch_end_epoch on annotation table','CREATE INDEX `IDX_annotation_org_id_dashboard_id_epoch_end_epoch` ON `annotation` (`org_id`,`dashboard_id`,`epoch_end`,`epoch`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(261,'Add index for org_id_epoch_end_epoch on annotation table','CREATE INDEX `IDX_annotation_org_id_epoch_end_epoch` ON `annotation` (`org_id`,`epoch_end`,`epoch`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(262,'Remove index org_id_epoch_epoch_end from annotation table','DROP INDEX `IDX_annotation_org_id_epoch_epoch_end`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(263,'Add index for alert_id on annotation table','CREATE INDEX `IDX_annotation_alert_id` ON `annotation` (`alert_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(264,'Increase tags column to length 4096','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(265,'Increase prev_state column to length 40 not null','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(266,'Increase new_state column to length 40 not null','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(267,'create test_data table',replace('CREATE TABLE IF NOT EXISTS `test_data` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `metric1` TEXT NULL\n, `metric2` TEXT NULL\n, `value_big_int` INTEGER NULL\n, `value_double` REAL NULL\n, `value_float` REAL NULL\n, `value_int` INTEGER NULL\n, `time_epoch` INTEGER NOT NULL\n, `time_date_time` DATETIME NOT NULL\n, `time_time_stamp` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(268,'create dashboard_version table v1',replace('CREATE TABLE IF NOT EXISTS `dashboard_version` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `dashboard_id` INTEGER NOT NULL\n, `parent_version` INTEGER NOT NULL\n, `restored_from` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `created_by` INTEGER NOT NULL\n, `message` TEXT NOT NULL\n, `data` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(269,'add index dashboard_version.dashboard_id','CREATE INDEX `IDX_dashboard_version_dashboard_id` ON `dashboard_version` (`dashboard_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(270,'add unique index dashboard_version.dashboard_id and dashboard_version.version','CREATE UNIQUE INDEX `UQE_dashboard_version_dashboard_id_version` ON `dashboard_version` (`dashboard_id`,`version`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(271,'Set dashboard version to 1 where 0','UPDATE dashboard SET version = 1 WHERE version = 0',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(272,'save existing dashboard data in dashboard_version table v1',replace('INSERT INTO dashboard_version\n(\n	dashboard_id,\n	version,\n	parent_version,\n	restored_from,\n	created,\n	created_by,\n	message,\n	data\n)\nSELECT\n	dashboard.id,\n	dashboard.version,\n	dashboard.version,\n	dashboard.version,\n	dashboard.updated,\n	COALESCE(dashboard.updated_by, -1),\n	'''',\n	dashboard.data\nFROM dashboard;','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(273,'alter dashboard_version.data to mediumtext v1','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(274,'create team table',replace('CREATE TABLE IF NOT EXISTS `team` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `name` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(275,'add index team.org_id','CREATE INDEX `IDX_team_org_id` ON `team` (`org_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(276,'add unique index team_org_id_name','CREATE UNIQUE INDEX `UQE_team_org_id_name` ON `team` (`org_id`,`name`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(277,'Add column uid in team','alter table `team` ADD COLUMN `uid` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(278,'Update uid column values in team','UPDATE team SET uid=printf(''t%09d'',id) WHERE uid IS NULL;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(279,'Add unique index team_org_id_uid','CREATE UNIQUE INDEX `UQE_team_org_id_uid` ON `team` (`org_id`,`uid`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(280,'create team member table',replace('CREATE TABLE IF NOT EXISTS `team_member` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `team_id` INTEGER NOT NULL\n, `user_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(281,'add index team_member.org_id','CREATE INDEX `IDX_team_member_org_id` ON `team_member` (`org_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(282,'add unique index team_member_org_id_team_id_user_id','CREATE UNIQUE INDEX `UQE_team_member_org_id_team_id_user_id` ON `team_member` (`org_id`,`team_id`,`user_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(283,'add index team_member.team_id','CREATE INDEX `IDX_team_member_team_id` ON `team_member` (`team_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(284,'Add column email to team table','alter table `team` ADD COLUMN `email` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(285,'Add column external to team_member table','alter table `team_member` ADD COLUMN `external` INTEGER NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(286,'Add column permission to team_member table','alter table `team_member` ADD COLUMN `permission` INTEGER NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(287,'add unique index team_member_user_id_org_id','CREATE INDEX `IDX_team_member_user_id_org_id` ON `team_member` (`user_id`,`org_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(288,'create dashboard acl table',replace('CREATE TABLE IF NOT EXISTS `dashboard_acl` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `dashboard_id` INTEGER NOT NULL\n, `user_id` INTEGER NULL\n, `team_id` INTEGER NULL\n, `permission` INTEGER NOT NULL DEFAULT 4\n, `role` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(289,'add index dashboard_acl_dashboard_id','CREATE INDEX `IDX_dashboard_acl_dashboard_id` ON `dashboard_acl` (`dashboard_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(290,'add unique index dashboard_acl_dashboard_id_user_id','CREATE UNIQUE INDEX `UQE_dashboard_acl_dashboard_id_user_id` ON `dashboard_acl` (`dashboard_id`,`user_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(291,'add unique index dashboard_acl_dashboard_id_team_id','CREATE UNIQUE INDEX `UQE_dashboard_acl_dashboard_id_team_id` ON `dashboard_acl` (`dashboard_id`,`team_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(292,'add index dashboard_acl_user_id','CREATE INDEX `IDX_dashboard_acl_user_id` ON `dashboard_acl` (`user_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(293,'add index dashboard_acl_team_id','CREATE INDEX `IDX_dashboard_acl_team_id` ON `dashboard_acl` (`team_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(294,'add index dashboard_acl_org_id_role','CREATE INDEX `IDX_dashboard_acl_org_id_role` ON `dashboard_acl` (`org_id`,`role`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(295,'add index dashboard_permission','CREATE INDEX `IDX_dashboard_acl_permission` ON `dashboard_acl` (`permission`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(296,'save default acl rules in dashboard_acl table',replace('\nINSERT INTO dashboard_acl\n	(\n		org_id,\n		dashboard_id,\n		permission,\n		role,\n		created,\n		updated\n	)\n	VALUES\n		(-1,-1, 1,''Viewer'',''2017-06-20'',''2017-06-20''),\n		(-1,-1, 2,''Editor'',''2017-06-20'',''2017-06-20'')\n	','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(297,'delete acl rules for deleted dashboards and folders','DELETE FROM dashboard_acl WHERE dashboard_id NOT IN (SELECT id FROM dashboard) AND dashboard_id != -1',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(298,'create tag table',replace('CREATE TABLE IF NOT EXISTS `tag` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `key` TEXT NOT NULL\n, `value` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(299,'add index tag.key_value','CREATE UNIQUE INDEX `UQE_tag_key_value` ON `tag` (`key`,`value`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(300,'create login attempt table',replace('CREATE TABLE IF NOT EXISTS `login_attempt` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `username` TEXT NOT NULL\n, `ip_address` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(301,'add index login_attempt.username','CREATE INDEX `IDX_login_attempt_username` ON `login_attempt` (`username`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(302,'drop index IDX_login_attempt_username - v1','DROP INDEX `IDX_login_attempt_username`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(303,'Rename table login_attempt to login_attempt_tmp_qwerty - v1','ALTER TABLE `login_attempt` RENAME TO `login_attempt_tmp_qwerty`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(304,'create login_attempt v2',replace('CREATE TABLE IF NOT EXISTS `login_attempt` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `username` TEXT NOT NULL\n, `ip_address` TEXT NOT NULL\n, `created` INTEGER NOT NULL DEFAULT 0\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(305,'create index IDX_login_attempt_username - v2','CREATE INDEX `IDX_login_attempt_username` ON `login_attempt` (`username`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(306,'copy login_attempt v1 to v2',replace('INSERT INTO `login_attempt` (`id`\n, `username`\n, `ip_address`) SELECT `id`\n, `username`\n, `ip_address` FROM `login_attempt_tmp_qwerty`','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(307,'drop login_attempt_tmp_qwerty','DROP TABLE IF EXISTS `login_attempt_tmp_qwerty`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(308,'create user auth table',replace('CREATE TABLE IF NOT EXISTS `user_auth` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `user_id` INTEGER NOT NULL\n, `auth_module` TEXT NOT NULL\n, `auth_id` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(309,'create index IDX_user_auth_auth_module_auth_id - v1','CREATE INDEX `IDX_user_auth_auth_module_auth_id` ON `user_auth` (`auth_module`,`auth_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(310,'alter user_auth.auth_id to length 190','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(311,'Add OAuth access token to user_auth','alter table `user_auth` ADD COLUMN `o_auth_access_token` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(312,'Add OAuth refresh token to user_auth','alter table `user_auth` ADD COLUMN `o_auth_refresh_token` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(313,'Add OAuth token type to user_auth','alter table `user_auth` ADD COLUMN `o_auth_token_type` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(314,'Add OAuth expiry to user_auth','alter table `user_auth` ADD COLUMN `o_auth_expiry` DATETIME NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(315,'Add index to user_id column in user_auth','CREATE INDEX `IDX_user_auth_user_id` ON `user_auth` (`user_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(316,'Add OAuth ID token to user_auth','alter table `user_auth` ADD COLUMN `o_auth_id_token` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(317,'create server_lock table',replace('CREATE TABLE IF NOT EXISTS `server_lock` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `operation_uid` TEXT NOT NULL\n, `version` INTEGER NOT NULL\n, `last_execution` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(318,'add index server_lock.operation_uid','CREATE UNIQUE INDEX `UQE_server_lock_operation_uid` ON `server_lock` (`operation_uid`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(319,'create user auth token table',replace('CREATE TABLE IF NOT EXISTS `user_auth_token` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `user_id` INTEGER NOT NULL\n, `auth_token` TEXT NOT NULL\n, `prev_auth_token` TEXT NOT NULL\n, `user_agent` TEXT NOT NULL\n, `client_ip` TEXT NOT NULL\n, `auth_token_seen` INTEGER NOT NULL\n, `seen_at` INTEGER NULL\n, `rotated_at` INTEGER NOT NULL\n, `created_at` INTEGER NOT NULL\n, `updated_at` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(320,'add unique index user_auth_token.auth_token','CREATE UNIQUE INDEX `UQE_user_auth_token_auth_token` ON `user_auth_token` (`auth_token`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(321,'add unique index user_auth_token.prev_auth_token','CREATE UNIQUE INDEX `UQE_user_auth_token_prev_auth_token` ON `user_auth_token` (`prev_auth_token`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(322,'add index user_auth_token.user_id','CREATE INDEX `IDX_user_auth_token_user_id` ON `user_auth_token` (`user_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(323,'Add revoked_at to the user auth token','alter table `user_auth_token` ADD COLUMN `revoked_at` INTEGER NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(324,'add index user_auth_token.revoked_at','CREATE INDEX `IDX_user_auth_token_revoked_at` ON `user_auth_token` (`revoked_at`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(325,'add external_session_id to user_auth_token','alter table `user_auth_token` ADD COLUMN `external_session_id` INTEGER NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(326,'create cache_data table',replace('CREATE TABLE IF NOT EXISTS `cache_data` (\n`cache_key` TEXT PRIMARY KEY NOT NULL\n, `data` BLOB NOT NULL\n, `expires` INTEGER NOT NULL\n, `created_at` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(327,'add unique index cache_data.cache_key','CREATE UNIQUE INDEX `UQE_cache_data_cache_key` ON `cache_data` (`cache_key`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(328,'create short_url table v1',replace('CREATE TABLE IF NOT EXISTS `short_url` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `uid` TEXT NOT NULL\n, `path` TEXT NOT NULL\n, `created_by` INTEGER NOT NULL\n, `created_at` INTEGER NOT NULL\n, `last_seen_at` INTEGER NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(329,'add index short_url.org_id-uid','CREATE UNIQUE INDEX `UQE_short_url_org_id_uid` ON `short_url` (`org_id`,`uid`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(330,'alter table short_url alter column created_by type to bigint','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(331,'delete alert_definition table','DROP TABLE IF EXISTS `alert_definition`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(332,'recreate alert_definition table',replace('CREATE TABLE IF NOT EXISTS `alert_definition` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `title` TEXT NOT NULL\n, `condition` TEXT NOT NULL\n, `data` TEXT NOT NULL\n, `updated` DATETIME NOT NULL\n, `interval_seconds` INTEGER NOT NULL DEFAULT 60\n, `version` INTEGER NOT NULL DEFAULT 0\n, `uid` TEXT NOT NULL DEFAULT 0\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(333,'add index in alert_definition on org_id and title columns','CREATE INDEX `IDX_alert_definition_org_id_title` ON `alert_definition` (`org_id`,`title`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(334,'add index in alert_definition on org_id and uid columns','CREATE INDEX `IDX_alert_definition_org_id_uid` ON `alert_definition` (`org_id`,`uid`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(335,'alter alert_definition table data column to mediumtext in mysql','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(336,'drop index in alert_definition on org_id and title columns','DROP INDEX `IDX_alert_definition_org_id_title`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(337,'drop index in alert_definition on org_id and uid columns','DROP INDEX `IDX_alert_definition_org_id_uid`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(338,'add unique index in alert_definition on org_id and title columns','CREATE UNIQUE INDEX `UQE_alert_definition_org_id_title` ON `alert_definition` (`org_id`,`title`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(339,'add unique index in alert_definition on org_id and uid columns','CREATE UNIQUE INDEX `UQE_alert_definition_org_id_uid` ON `alert_definition` (`org_id`,`uid`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(340,'Add column paused in alert_definition','alter table `alert_definition` ADD COLUMN `paused` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(341,'drop alert_definition table','DROP TABLE IF EXISTS `alert_definition`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(342,'delete alert_definition_version table','DROP TABLE IF EXISTS `alert_definition_version`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(343,'recreate alert_definition_version table',replace('CREATE TABLE IF NOT EXISTS `alert_definition_version` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `alert_definition_id` INTEGER NOT NULL\n, `alert_definition_uid` TEXT NOT NULL DEFAULT 0\n, `parent_version` INTEGER NOT NULL\n, `restored_from` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `title` TEXT NOT NULL\n, `condition` TEXT NOT NULL\n, `data` TEXT NOT NULL\n, `interval_seconds` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(344,'add index in alert_definition_version table on alert_definition_id and version columns','CREATE UNIQUE INDEX `UQE_alert_definition_version_alert_definition_id_version` ON `alert_definition_version` (`alert_definition_id`,`version`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(345,'add index in alert_definition_version table on alert_definition_uid and version columns','CREATE UNIQUE INDEX `UQE_alert_definition_version_alert_definition_uid_version` ON `alert_definition_version` (`alert_definition_uid`,`version`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(346,'alter alert_definition_version table data column to mediumtext in mysql','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(347,'drop alert_definition_version table','DROP TABLE IF EXISTS `alert_definition_version`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(348,'create alert_instance table',replace('CREATE TABLE IF NOT EXISTS `alert_instance` (\n`def_org_id` INTEGER NOT NULL\n, `def_uid` TEXT NOT NULL DEFAULT 0\n, `labels` TEXT NOT NULL\n, `labels_hash` TEXT NOT NULL\n, `current_state` TEXT NOT NULL\n, `current_state_since` INTEGER NOT NULL\n, `last_eval_time` INTEGER NOT NULL\n, PRIMARY KEY ( `def_org_id`,`def_uid`,`labels_hash` ));','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(349,'add index in alert_instance table on def_org_id, def_uid and current_state columns','CREATE INDEX `IDX_alert_instance_def_org_id_def_uid_current_state` ON `alert_instance` (`def_org_id`,`def_uid`,`current_state`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(350,'add index in alert_instance table on def_org_id, current_state columns','CREATE INDEX `IDX_alert_instance_def_org_id_current_state` ON `alert_instance` (`def_org_id`,`current_state`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(351,'add column current_state_end to alert_instance','alter table `alert_instance` ADD COLUMN `current_state_end` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(352,'remove index def_org_id, def_uid, current_state on alert_instance','DROP INDEX `IDX_alert_instance_def_org_id_def_uid_current_state`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(353,'remove index def_org_id, current_state on alert_instance','DROP INDEX `IDX_alert_instance_def_org_id_current_state`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(354,'rename def_org_id to rule_org_id in alert_instance','ALTER TABLE alert_instance RENAME COLUMN def_org_id TO rule_org_id;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(355,'rename def_uid to rule_uid in alert_instance','ALTER TABLE alert_instance RENAME COLUMN def_uid TO rule_uid;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(356,'add index rule_org_id, rule_uid, current_state on alert_instance','CREATE INDEX `IDX_alert_instance_rule_org_id_rule_uid_current_state` ON `alert_instance` (`rule_org_id`,`rule_uid`,`current_state`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(357,'add index rule_org_id, current_state on alert_instance','CREATE INDEX `IDX_alert_instance_rule_org_id_current_state` ON `alert_instance` (`rule_org_id`,`current_state`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(358,'add current_reason column related to current_state','alter table `alert_instance` ADD COLUMN `current_reason` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(359,'add result_fingerprint column to alert_instance','alter table `alert_instance` ADD COLUMN `result_fingerprint` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(360,'create alert_rule table',replace('CREATE TABLE IF NOT EXISTS `alert_rule` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `title` TEXT NOT NULL\n, `condition` TEXT NOT NULL\n, `data` TEXT NOT NULL\n, `updated` DATETIME NOT NULL\n, `interval_seconds` INTEGER NOT NULL DEFAULT 60\n, `version` INTEGER NOT NULL DEFAULT 0\n, `uid` TEXT NOT NULL DEFAULT 0\n, `namespace_uid` TEXT NOT NULL\n, `rule_group` TEXT NOT NULL\n, `no_data_state` TEXT NOT NULL DEFAULT ''NoData''\n, `exec_err_state` TEXT NOT NULL DEFAULT ''Alerting''\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(361,'add index in alert_rule on org_id and title columns','CREATE UNIQUE INDEX `UQE_alert_rule_org_id_title` ON `alert_rule` (`org_id`,`title`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(362,'add index in alert_rule on org_id and uid columns','CREATE UNIQUE INDEX `UQE_alert_rule_org_id_uid` ON `alert_rule` (`org_id`,`uid`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(363,'add index in alert_rule on org_id, namespace_uid, group_uid columns','CREATE INDEX `IDX_alert_rule_org_id_namespace_uid_rule_group` ON `alert_rule` (`org_id`,`namespace_uid`,`rule_group`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(364,'alter alert_rule table data column to mediumtext in mysql','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(365,'add column for to alert_rule','alter table `alert_rule` ADD COLUMN `for` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(366,'add column annotations to alert_rule','alter table `alert_rule` ADD COLUMN `annotations` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(367,'add column labels to alert_rule','alter table `alert_rule` ADD COLUMN `labels` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(368,'remove unique index from alert_rule on org_id, title columns','DROP INDEX `UQE_alert_rule_org_id_title`',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(369,'add index in alert_rule on org_id, namespase_uid and title columns','CREATE UNIQUE INDEX `UQE_alert_rule_org_id_namespace_uid_title` ON `alert_rule` (`org_id`,`namespace_uid`,`title`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(370,'add dashboard_uid column to alert_rule','alter table `alert_rule` ADD COLUMN `dashboard_uid` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(371,'add panel_id column to alert_rule','alter table `alert_rule` ADD COLUMN `panel_id` INTEGER NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(372,'add index in alert_rule on org_id, dashboard_uid and panel_id columns','CREATE INDEX `IDX_alert_rule_org_id_dashboard_uid_panel_id` ON `alert_rule` (`org_id`,`dashboard_uid`,`panel_id`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(373,'add rule_group_idx column to alert_rule','alter table `alert_rule` ADD COLUMN `rule_group_idx` INTEGER NOT NULL DEFAULT 1 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(374,'add is_paused column to alert_rule table','alter table `alert_rule` ADD COLUMN `is_paused` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(375,'fix is_paused column for alert_rule table','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(376,'create alert_rule_version table',replace('CREATE TABLE IF NOT EXISTS `alert_rule_version` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `rule_org_id` INTEGER NOT NULL\n, `rule_uid` TEXT NOT NULL DEFAULT 0\n, `rule_namespace_uid` TEXT NOT NULL\n, `rule_group` TEXT NOT NULL\n, `parent_version` INTEGER NOT NULL\n, `restored_from` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `title` TEXT NOT NULL\n, `condition` TEXT NOT NULL\n, `data` TEXT NOT NULL\n, `interval_seconds` INTEGER NOT NULL\n, `no_data_state` TEXT NOT NULL DEFAULT ''NoData''\n, `exec_err_state` TEXT NOT NULL DEFAULT ''Alerting''\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(377,'add index in alert_rule_version table on rule_org_id, rule_uid and version columns','CREATE UNIQUE INDEX `UQE_alert_rule_version_rule_org_id_rule_uid_version` ON `alert_rule_version` (`rule_org_id`,`rule_uid`,`version`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(378,'add index in alert_rule_version table on rule_org_id, rule_namespace_uid and rule_group columns','CREATE INDEX `IDX_alert_rule_version_rule_org_id_rule_namespace_uid_rule_group` ON `alert_rule_version` (`rule_org_id`,`rule_namespace_uid`,`rule_group`);',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(379,'alter alert_rule_version table data column to mediumtext in mysql','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(380,'add column for to alert_rule_version','alter table `alert_rule_version` ADD COLUMN `for` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(381,'add column annotations to alert_rule_version','alter table `alert_rule_version` ADD COLUMN `annotations` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(382,'add column labels to alert_rule_version','alter table `alert_rule_version` ADD COLUMN `labels` TEXT NULL ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(383,'add rule_group_idx column to alert_rule_version','alter table `alert_rule_version` ADD COLUMN `rule_group_idx` INTEGER NOT NULL DEFAULT 1 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(384,'add is_paused column to alert_rule_versions table','alter table `alert_rule_version` ADD COLUMN `is_paused` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(385,'fix is_paused column for alert_rule_version table','SELECT 0;',1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(386,'create_alert_configuration_table',replace('CREATE TABLE IF NOT EXISTS `alert_configuration` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `alertmanager_configuration` TEXT NOT NULL\n, `configuration_version` TEXT NOT NULL\n, `created_at` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:12');
INSERT INTO migration_log VALUES(387,'Add column default in alert_configuration','alter table `alert_configuration` ADD COLUMN `default` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(388,'alert alert_configuration alertmanager_configuration column from TEXT to MEDIUMTEXT if mysql','SELECT 0;',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(389,'add column org_id in alert_configuration','alter table `alert_configuration` ADD COLUMN `org_id` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(390,'add index in alert_configuration table on org_id column','CREATE INDEX `IDX_alert_configuration_org_id` ON `alert_configuration` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(391,'add configuration_hash column to alert_configuration','alter table `alert_configuration` ADD COLUMN `configuration_hash` TEXT NOT NULL DEFAULT ''not-yet-calculated'' ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(392,'create_ngalert_configuration_table',replace('CREATE TABLE IF NOT EXISTS `ngalert_configuration` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `alertmanagers` TEXT NULL\n, `created_at` INTEGER NOT NULL\n, `updated_at` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(393,'add index in ngalert_configuration on org_id column','CREATE UNIQUE INDEX `UQE_ngalert_configuration_org_id` ON `ngalert_configuration` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(394,'add column send_alerts_to in ngalert_configuration','alter table `ngalert_configuration` ADD COLUMN `send_alerts_to` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(395,'create provenance_type table',replace('CREATE TABLE IF NOT EXISTS `provenance_type` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `record_key` TEXT NOT NULL\n, `record_type` TEXT NOT NULL\n, `provenance` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(396,'add index to uniquify (record_key, record_type, org_id) columns','CREATE UNIQUE INDEX `UQE_provenance_type_record_type_record_key_org_id` ON `provenance_type` (`record_type`,`record_key`,`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(397,'create alert_image table',replace('CREATE TABLE IF NOT EXISTS `alert_image` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `token` TEXT NOT NULL\n, `path` TEXT NOT NULL\n, `url` TEXT NOT NULL\n, `created_at` DATETIME NOT NULL\n, `expires_at` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(398,'add unique index on token to alert_image table','CREATE UNIQUE INDEX `UQE_alert_image_token` ON `alert_image` (`token`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(399,'support longer URLs in alert_image table','SELECT 0;',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(400,'create_alert_configuration_history_table',replace('CREATE TABLE IF NOT EXISTS `alert_configuration_history` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL DEFAULT 0\n, `alertmanager_configuration` TEXT NOT NULL\n, `configuration_hash` TEXT NOT NULL DEFAULT ''not-yet-calculated''\n, `configuration_version` TEXT NOT NULL\n, `created_at` INTEGER NOT NULL\n, `default` INTEGER NOT NULL DEFAULT 0\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(401,'drop non-unique orgID index on alert_configuration','DROP INDEX `IDX_alert_configuration_org_id`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(402,'drop unique orgID index on alert_configuration if exists','DROP INDEX `UQE_alert_configuration_org_id`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(403,'extract alertmanager configuration history to separate table','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(404,'add unique index on orgID to alert_configuration','CREATE UNIQUE INDEX `UQE_alert_configuration_org_id` ON `alert_configuration` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(405,'add last_applied column to alert_configuration_history','alter table `alert_configuration_history` ADD COLUMN `last_applied` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(406,'create library_element table v1',replace('CREATE TABLE IF NOT EXISTS `library_element` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `folder_id` INTEGER NOT NULL\n, `uid` TEXT NOT NULL\n, `name` TEXT NOT NULL\n, `kind` INTEGER NOT NULL\n, `type` TEXT NOT NULL\n, `description` TEXT NOT NULL\n, `model` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `created_by` INTEGER NOT NULL\n, `updated` DATETIME NOT NULL\n, `updated_by` INTEGER NOT NULL\n, `version` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(407,'add index library_element org_id-folder_id-name-kind','CREATE UNIQUE INDEX `UQE_library_element_org_id_folder_id_name_kind` ON `library_element` (`org_id`,`folder_id`,`name`,`kind`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(408,'create library_element_connection table v1',replace('CREATE TABLE IF NOT EXISTS `library_element_connection` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `element_id` INTEGER NOT NULL\n, `kind` INTEGER NOT NULL\n, `connection_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `created_by` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(409,'add index library_element_connection element_id-kind-connection_id','CREATE UNIQUE INDEX `UQE_library_element_connection_element_id_kind_connection_id` ON `library_element_connection` (`element_id`,`kind`,`connection_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(410,'add unique index library_element org_id_uid','CREATE UNIQUE INDEX `UQE_library_element_org_id_uid` ON `library_element` (`org_id`,`uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(411,'increase max description length to 2048','-- NOT REQUIRED',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(412,'alter library_element model to mediumtext','SELECT 0;',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(413,'add library_element folder uid','alter table `library_element` ADD COLUMN `folder_uid` TEXT NULL ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(414,'populate library_element folder_uid',replace('UPDATE library_element\n	SET folder_uid = dashboard.uid\n	FROM dashboard\n	WHERE library_element.folder_id = dashboard.id AND library_element.org_id = dashboard.org_id','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(415,'add index library_element org_id-folder_uid-name-kind','CREATE UNIQUE INDEX `UQE_library_element_org_id_folder_uid_name_kind` ON `library_element` (`org_id`,`folder_uid`,`name`,`kind`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(416,'clone move dashboard alerts to unified alerting','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(417,'create data_keys table',replace('CREATE TABLE IF NOT EXISTS `data_keys` (\n`name` TEXT PRIMARY KEY NOT NULL\n, `active` INTEGER NOT NULL\n, `scope` TEXT NOT NULL\n, `provider` TEXT NOT NULL\n, `encrypted_data` BLOB NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(418,'create secrets table',replace('CREATE TABLE IF NOT EXISTS `secrets` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `namespace` TEXT NOT NULL\n, `type` TEXT NOT NULL\n, `value` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(419,'rename data_keys name column to id','ALTER TABLE `data_keys` RENAME COLUMN `name` TO `id`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(420,'add name column into data_keys','alter table `data_keys` ADD COLUMN `name` TEXT NOT NULL DEFAULT '''' ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(421,'copy data_keys id column values into name','UPDATE data_keys SET name = id',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(422,'rename data_keys name column to label','ALTER TABLE `data_keys` RENAME COLUMN `name` TO `label`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(423,'rename data_keys id column back to name','ALTER TABLE `data_keys` RENAME COLUMN `id` TO `name`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(424,'create kv_store table v1',replace('CREATE TABLE IF NOT EXISTS `kv_store` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `namespace` TEXT NOT NULL\n, `key` TEXT NOT NULL\n, `value` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(425,'add index kv_store.org_id-namespace-key','CREATE UNIQUE INDEX `UQE_kv_store_org_id_namespace_key` ON `kv_store` (`org_id`,`namespace`,`key`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(426,'update dashboard_uid and panel_id from existing annotations','set dashboard_uid and panel_id migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(427,'create permission table',replace('CREATE TABLE IF NOT EXISTS `permission` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `role_id` INTEGER NOT NULL\n, `action` TEXT NOT NULL\n, `scope` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(428,'add unique index permission.role_id','CREATE INDEX `IDX_permission_role_id` ON `permission` (`role_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(429,'add unique index role_id_action_scope','CREATE UNIQUE INDEX `UQE_permission_role_id_action_scope` ON `permission` (`role_id`,`action`,`scope`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(430,'create role table',replace('CREATE TABLE IF NOT EXISTS `role` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `name` TEXT NOT NULL\n, `description` TEXT NULL\n, `version` INTEGER NOT NULL\n, `org_id` INTEGER NOT NULL\n, `uid` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(431,'add column display_name','alter table `role` ADD COLUMN `display_name` TEXT NULL ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(432,'add column group_name','alter table `role` ADD COLUMN `group_name` TEXT NULL ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(433,'add index role.org_id','CREATE INDEX `IDX_role_org_id` ON `role` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(434,'add unique index role_org_id_name','CREATE UNIQUE INDEX `UQE_role_org_id_name` ON `role` (`org_id`,`name`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(435,'add index role_org_id_uid','CREATE UNIQUE INDEX `UQE_role_org_id_uid` ON `role` (`org_id`,`uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(436,'create team role table',replace('CREATE TABLE IF NOT EXISTS `team_role` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `team_id` INTEGER NOT NULL\n, `role_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(437,'add index team_role.org_id','CREATE INDEX `IDX_team_role_org_id` ON `team_role` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(438,'add unique index team_role_org_id_team_id_role_id','CREATE UNIQUE INDEX `UQE_team_role_org_id_team_id_role_id` ON `team_role` (`org_id`,`team_id`,`role_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(439,'add index team_role.team_id','CREATE INDEX `IDX_team_role_team_id` ON `team_role` (`team_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(440,'create user role table',replace('CREATE TABLE IF NOT EXISTS `user_role` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `user_id` INTEGER NOT NULL\n, `role_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(441,'add index user_role.org_id','CREATE INDEX `IDX_user_role_org_id` ON `user_role` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(442,'add unique index user_role_org_id_user_id_role_id','CREATE UNIQUE INDEX `UQE_user_role_org_id_user_id_role_id` ON `user_role` (`org_id`,`user_id`,`role_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(443,'add index user_role.user_id','CREATE INDEX `IDX_user_role_user_id` ON `user_role` (`user_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(444,'create builtin role table',replace('CREATE TABLE IF NOT EXISTS `builtin_role` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `role` TEXT NOT NULL\n, `role_id` INTEGER NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(445,'add index builtin_role.role_id','CREATE INDEX `IDX_builtin_role_role_id` ON `builtin_role` (`role_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(446,'add index builtin_role.name','CREATE INDEX `IDX_builtin_role_role` ON `builtin_role` (`role`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(447,'Add column org_id to builtin_role table','alter table `builtin_role` ADD COLUMN `org_id` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(448,'add index builtin_role.org_id','CREATE INDEX `IDX_builtin_role_org_id` ON `builtin_role` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(449,'add unique index builtin_role_org_id_role_id_role','CREATE UNIQUE INDEX `UQE_builtin_role_org_id_role_id_role` ON `builtin_role` (`org_id`,`role_id`,`role`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(450,'Remove unique index role_org_id_uid','DROP INDEX `UQE_role_org_id_uid`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(451,'add unique index role.uid','CREATE UNIQUE INDEX `UQE_role_uid` ON `role` (`uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(452,'create seed assignment table',replace('CREATE TABLE IF NOT EXISTS `seed_assignment` (\n`builtin_role` TEXT NOT NULL\n, `role_name` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(453,'add unique index builtin_role_role_name','CREATE UNIQUE INDEX `UQE_seed_assignment_builtin_role_role_name` ON `seed_assignment` (`builtin_role`,`role_name`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(454,'add column hidden to role table','alter table `role` ADD COLUMN `hidden` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(455,'permission kind migration','alter table `permission` ADD COLUMN `kind` TEXT NOT NULL DEFAULT '''' ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(456,'permission attribute migration','alter table `permission` ADD COLUMN `attribute` TEXT NOT NULL DEFAULT '''' ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(457,'permission identifier migration','alter table `permission` ADD COLUMN `identifier` TEXT NOT NULL DEFAULT '''' ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(458,'add permission identifier index','CREATE INDEX `IDX_permission_identifier` ON `permission` (`identifier`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(459,'add permission action scope role_id index','CREATE UNIQUE INDEX `UQE_permission_action_scope_role_id` ON `permission` (`action`,`scope`,`role_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(460,'remove permission role_id action scope index','DROP INDEX `UQE_permission_role_id_action_scope`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(461,'add group mapping UID column to user_role table','alter table `user_role` ADD COLUMN `group_mapping_uid` TEXT NULL DEFAULT '''' ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(462,'add user_role org ID, user ID, role ID, group mapping UID index','CREATE UNIQUE INDEX `UQE_user_role_org_id_user_id_role_id_group_mapping_uid` ON `user_role` (`org_id`,`user_id`,`role_id`,`group_mapping_uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(463,'remove user_role org ID, user ID, role ID index','DROP INDEX `UQE_user_role_org_id_user_id_role_id`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(464,'create query_history table v1',replace('CREATE TABLE IF NOT EXISTS `query_history` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `uid` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `datasource_uid` TEXT NOT NULL\n, `created_by` INTEGER NOT NULL\n, `created_at` INTEGER NOT NULL\n, `comment` TEXT NOT NULL\n, `queries` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(465,'add index query_history.org_id-created_by-datasource_uid','CREATE INDEX `IDX_query_history_org_id_created_by_datasource_uid` ON `query_history` (`org_id`,`created_by`,`datasource_uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(466,'alter table query_history alter column created_by type to bigint','SELECT 0;',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(467,'create query_history_details table v1',replace('CREATE TABLE IF NOT EXISTS `query_history_details` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `query_history_item_uid` TEXT NOT NULL\n, `datasource_uid` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(468,'rbac disabled migrator','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(469,'teams permissions migration','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(470,'dashboard permissions','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(471,'dashboard permissions uid scopes','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(472,'drop managed folder create actions','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(473,'alerting notification permissions','code migration',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(474,'create query_history_star table v1',replace('CREATE TABLE IF NOT EXISTS `query_history_star` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `query_uid` TEXT NOT NULL\n, `user_id` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(475,'add index query_history.user_id-query_uid','CREATE UNIQUE INDEX `UQE_query_history_star_user_id_query_uid` ON `query_history_star` (`user_id`,`query_uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(476,'add column org_id in query_history_star','alter table `query_history_star` ADD COLUMN `org_id` INTEGER NOT NULL DEFAULT 1 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(477,'alter table query_history_star_mig column user_id type to bigint','SELECT 0;',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(478,'create correlation table v1',replace('CREATE TABLE IF NOT EXISTS `correlation` (\n`uid` TEXT NOT NULL\n, `source_uid` TEXT NOT NULL\n, `target_uid` TEXT NULL\n, `label` TEXT NOT NULL\n, `description` TEXT NOT NULL\n, PRIMARY KEY ( `uid`,`source_uid` ));','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(479,'add index correlations.uid','CREATE INDEX `IDX_correlation_uid` ON `correlation` (`uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(480,'add index correlations.source_uid','CREATE INDEX `IDX_correlation_source_uid` ON `correlation` (`source_uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(481,'add correlation config column','alter table `correlation` ADD COLUMN `config` TEXT NULL ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(482,'drop index IDX_correlation_uid - v1','DROP INDEX `IDX_correlation_uid`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(483,'drop index IDX_correlation_source_uid - v1','DROP INDEX `IDX_correlation_source_uid`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(484,'Rename table correlation to correlation_tmp_qwerty - v1','ALTER TABLE `correlation` RENAME TO `correlation_tmp_qwerty`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(485,'create correlation v2',replace('CREATE TABLE IF NOT EXISTS `correlation` (\n`uid` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL DEFAULT 0\n, `source_uid` TEXT NOT NULL\n, `target_uid` TEXT NULL\n, `label` TEXT NOT NULL\n, `description` TEXT NOT NULL\n, `config` TEXT NULL\n, PRIMARY KEY ( `uid`,`org_id`,`source_uid` ));','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(486,'create index IDX_correlation_uid - v2','CREATE INDEX `IDX_correlation_uid` ON `correlation` (`uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(487,'create index IDX_correlation_source_uid - v2','CREATE INDEX `IDX_correlation_source_uid` ON `correlation` (`source_uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(488,'create index IDX_correlation_org_id - v2','CREATE INDEX `IDX_correlation_org_id` ON `correlation` (`org_id`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(489,'copy correlation v1 to v2',replace('INSERT INTO `correlation` (`uid`\n, `source_uid`\n, `target_uid`\n, `label`\n, `description`\n, `config`) SELECT `uid`\n, `source_uid`\n, `target_uid`\n, `label`\n, `description`\n, `config` FROM `correlation_tmp_qwerty`','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(490,'drop correlation_tmp_qwerty','DROP TABLE IF EXISTS `correlation_tmp_qwerty`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(491,'add provisioning column','alter table `correlation` ADD COLUMN `provisioned` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(492,'add type column','alter table `correlation` ADD COLUMN `type` TEXT NOT NULL DEFAULT ''query'' ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(493,'create entity_events table',replace('CREATE TABLE IF NOT EXISTS `entity_event` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `entity_id` TEXT NOT NULL\n, `event_type` TEXT NOT NULL\n, `created` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(494,'create dashboard public config v1',replace('CREATE TABLE IF NOT EXISTS `dashboard_public_config` (\n`uid` TEXT PRIMARY KEY NOT NULL\n, `dashboard_uid` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `time_settings` TEXT NOT NULL\n, `refresh_rate` INTEGER NOT NULL DEFAULT 30\n, `template_variables` TEXT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(495,'drop index UQE_dashboard_public_config_uid - v1','DROP INDEX `UQE_dashboard_public_config_uid`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(496,'drop index IDX_dashboard_public_config_org_id_dashboard_uid - v1','DROP INDEX `IDX_dashboard_public_config_org_id_dashboard_uid`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(497,'Drop old dashboard public config table','DROP TABLE IF EXISTS `dashboard_public_config`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(498,'recreate dashboard public config v1',replace('CREATE TABLE IF NOT EXISTS `dashboard_public_config` (\n`uid` TEXT PRIMARY KEY NOT NULL\n, `dashboard_uid` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `time_settings` TEXT NOT NULL\n, `refresh_rate` INTEGER NOT NULL DEFAULT 30\n, `template_variables` TEXT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(499,'create index UQE_dashboard_public_config_uid - v1','CREATE UNIQUE INDEX `UQE_dashboard_public_config_uid` ON `dashboard_public_config` (`uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(500,'create index IDX_dashboard_public_config_org_id_dashboard_uid - v1','CREATE INDEX `IDX_dashboard_public_config_org_id_dashboard_uid` ON `dashboard_public_config` (`org_id`,`dashboard_uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(501,'drop index UQE_dashboard_public_config_uid - v2','DROP INDEX `UQE_dashboard_public_config_uid`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(502,'drop index IDX_dashboard_public_config_org_id_dashboard_uid - v2','DROP INDEX `IDX_dashboard_public_config_org_id_dashboard_uid`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(503,'Drop public config table','DROP TABLE IF EXISTS `dashboard_public_config`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(504,'Recreate dashboard public config v2',replace('CREATE TABLE IF NOT EXISTS `dashboard_public_config` (\n`uid` TEXT PRIMARY KEY NOT NULL\n, `dashboard_uid` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `time_settings` TEXT NULL\n, `template_variables` TEXT NULL\n, `access_token` TEXT NOT NULL\n, `created_by` INTEGER NOT NULL\n, `updated_by` INTEGER NULL\n, `created_at` DATETIME NOT NULL\n, `updated_at` DATETIME NULL\n, `is_enabled` INTEGER NOT NULL DEFAULT 0\n);','\n',char(10)),1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(505,'create index UQE_dashboard_public_config_uid - v2','CREATE UNIQUE INDEX `UQE_dashboard_public_config_uid` ON `dashboard_public_config` (`uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(506,'create index IDX_dashboard_public_config_org_id_dashboard_uid - v2','CREATE INDEX `IDX_dashboard_public_config_org_id_dashboard_uid` ON `dashboard_public_config` (`org_id`,`dashboard_uid`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(507,'create index UQE_dashboard_public_config_access_token - v2','CREATE UNIQUE INDEX `UQE_dashboard_public_config_access_token` ON `dashboard_public_config` (`access_token`);',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(508,'Rename table dashboard_public_config to dashboard_public - v2','ALTER TABLE `dashboard_public_config` RENAME TO `dashboard_public`',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(509,'add annotations_enabled column','alter table `dashboard_public` ADD COLUMN `annotations_enabled` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:13');
INSERT INTO migration_log VALUES(510,'add time_selection_enabled column','alter table `dashboard_public` ADD COLUMN `time_selection_enabled` INTEGER NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(511,'delete orphaned public dashboards','DELETE FROM dashboard_public WHERE dashboard_uid NOT IN (SELECT uid FROM dashboard)',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(512,'add share column','alter table `dashboard_public` ADD COLUMN `share` TEXT NOT NULL DEFAULT ''public'' ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(513,'backfill empty share column fields with default of public','UPDATE dashboard_public SET share=''public'' WHERE share=''''',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(514,'create file table',replace('CREATE TABLE IF NOT EXISTS `file` (\n`path` TEXT NOT NULL\n, `path_hash` TEXT NOT NULL\n, `parent_folder_path_hash` TEXT NOT NULL\n, `contents` BLOB NOT NULL\n, `etag` TEXT NOT NULL\n, `cache_control` TEXT NOT NULL\n, `content_disposition` TEXT NOT NULL\n, `updated` DATETIME NOT NULL\n, `created` DATETIME NOT NULL\n, `size` INTEGER NOT NULL\n, `mime_type` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(515,'file table idx: path natural pk','CREATE UNIQUE INDEX `UQE_file_path_hash` ON `file` (`path_hash`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(516,'file table idx: parent_folder_path_hash fast folder retrieval','CREATE INDEX `IDX_file_parent_folder_path_hash` ON `file` (`parent_folder_path_hash`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(517,'create file_meta table',replace('CREATE TABLE IF NOT EXISTS `file_meta` (\n`path_hash` TEXT NOT NULL\n, `key` TEXT NOT NULL\n, `value` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(518,'file table idx: path key','CREATE UNIQUE INDEX `UQE_file_meta_path_hash_key` ON `file_meta` (`path_hash`,`key`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(519,'set path collation in file table','SELECT 0;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(520,'migrate contents column to mediumblob for MySQL','SELECT 0;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(521,'managed permissions migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(522,'managed folder permissions alert actions migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(523,'RBAC action name migrator','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(524,'Add UID column to playlist','alter table `playlist` ADD COLUMN `uid` TEXT NOT NULL DEFAULT 0 ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(525,'Update uid column values in playlist','UPDATE playlist SET uid=printf(''%d'',id);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(526,'Add index for uid in playlist','CREATE UNIQUE INDEX `UQE_playlist_org_id_uid` ON `playlist` (`org_id`,`uid`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(527,'update group index for alert rules','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(528,'managed folder permissions alert actions repeated migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(529,'admin only folder/dashboard permission','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(530,'add action column to seed_assignment','alter table `seed_assignment` ADD COLUMN `action` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(531,'add scope column to seed_assignment','alter table `seed_assignment` ADD COLUMN `scope` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(532,'remove unique index builtin_role_role_name before nullable update','DROP INDEX `UQE_seed_assignment_builtin_role_role_name`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(533,'update seed_assignment role_name column to nullable',replace('ALTER TABLE seed_assignment ADD COLUMN tmp_role_name VARCHAR(190) DEFAULT NULL;\nUPDATE seed_assignment SET tmp_role_name = role_name;\nALTER TABLE seed_assignment DROP COLUMN role_name;\nALTER TABLE seed_assignment RENAME COLUMN tmp_role_name TO role_name;','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(534,'add unique index builtin_role_name back','CREATE UNIQUE INDEX `UQE_seed_assignment_builtin_role_role_name` ON `seed_assignment` (`builtin_role`,`role_name`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(535,'add unique index builtin_role_action_scope','CREATE UNIQUE INDEX `UQE_seed_assignment_builtin_role_action_scope` ON `seed_assignment` (`builtin_role`,`action`,`scope`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(536,'add primary key to seed_assigment','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(537,'add origin column to seed_assignment','alter table `seed_assignment` ADD COLUMN `origin` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(538,'add origin to plugin seed_assignment','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(539,'prevent seeding OnCall access','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(540,'managed folder permissions alert actions repeated fixed migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(541,'managed folder permissions library panel actions migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(542,'migrate external alertmanagers to datsourcse','migrate external alertmanagers to datasource',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(543,'create folder table',replace('CREATE TABLE IF NOT EXISTS `folder` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `uid` TEXT NOT NULL\n, `org_id` INTEGER NOT NULL\n, `title` TEXT NOT NULL\n, `description` TEXT NULL\n, `parent_uid` TEXT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(544,'Add index for parent_uid','CREATE INDEX `IDX_folder_parent_uid_org_id` ON `folder` (`parent_uid`,`org_id`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(545,'Add unique index for folder.uid and folder.org_id','CREATE UNIQUE INDEX `UQE_folder_uid_org_id` ON `folder` (`uid`,`org_id`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(546,'Update folder title length','-- NOT REQUIRED',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(547,'Add unique index for folder.title and folder.parent_uid','CREATE UNIQUE INDEX `UQE_folder_title_parent_uid` ON `folder` (`title`,`parent_uid`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(548,'Remove unique index for folder.title and folder.parent_uid','DROP INDEX `UQE_folder_title_parent_uid`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(549,'Add unique index for title, parent_uid, and org_id','CREATE UNIQUE INDEX `UQE_folder_title_parent_uid_org_id` ON `folder` (`title`,`parent_uid`,`org_id`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(550,'Sync dashboard and folder table',replace('\n			INSERT INTO folder (uid, org_id, title, created, updated)\n			SELECT uid, org_id, title, created, updated FROM dashboard WHERE is_folder = 1\n			ON CONFLICT DO UPDATE SET title=excluded.title, updated=excluded.updated\n		','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(551,'Remove ghost folders from the folder table',replace('\n			DELETE FROM folder WHERE NOT EXISTS\n				(SELECT 1 FROM dashboard WHERE dashboard.uid = folder.uid AND dashboard.org_id = folder.org_id AND dashboard.is_folder = true)\n	','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(552,'Remove unique index UQE_folder_uid_org_id','DROP INDEX `UQE_folder_uid_org_id`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(553,'Add unique index UQE_folder_org_id_uid','CREATE UNIQUE INDEX `UQE_folder_org_id_uid` ON `folder` (`org_id`,`uid`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(554,'Remove unique index UQE_folder_title_parent_uid_org_id','DROP INDEX `UQE_folder_title_parent_uid_org_id`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(555,'Add unique index UQE_folder_org_id_parent_uid_title','CREATE UNIQUE INDEX `UQE_folder_org_id_parent_uid_title` ON `folder` (`org_id`,`parent_uid`,`title`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(556,'Remove index IDX_folder_parent_uid_org_id','DROP INDEX `IDX_folder_parent_uid_org_id`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(557,'Remove unique index UQE_folder_org_id_parent_uid_title','DROP INDEX `UQE_folder_org_id_parent_uid_title`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(558,'create anon_device table',replace('CREATE TABLE IF NOT EXISTS `anon_device` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `client_ip` TEXT NOT NULL\n, `created_at` DATETIME NOT NULL\n, `device_id` TEXT NOT NULL\n, `updated_at` DATETIME NOT NULL\n, `user_agent` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(559,'add unique index anon_device.device_id','CREATE UNIQUE INDEX `UQE_anon_device_device_id` ON `anon_device` (`device_id`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(560,'add index anon_device.updated_at','CREATE INDEX `IDX_anon_device_updated_at` ON `anon_device` (`updated_at`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(561,'create signing_key table',replace('CREATE TABLE IF NOT EXISTS `signing_key` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `key_id` TEXT NOT NULL\n, `private_key` TEXT NOT NULL\n, `added_at` DATETIME NOT NULL\n, `expires_at` DATETIME NULL\n, `alg` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(562,'add unique index signing_key.key_id','CREATE UNIQUE INDEX `UQE_signing_key_key_id` ON `signing_key` (`key_id`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(563,'set legacy alert migration status in kvstore','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(564,'migrate record of created folders during legacy migration to kvstore','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(565,'Add folder_uid for dashboard','alter table `dashboard` ADD COLUMN `folder_uid` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(566,'Populate dashboard folder_uid column','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(567,'Add unique index for dashboard_org_id_folder_uid_title','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(568,'Delete unique index for dashboard_org_id_folder_id_title','DROP INDEX `UQE_dashboard_org_id_folder_id_title`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(569,'Delete unique index for dashboard_org_id_folder_uid_title','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(570,'Add unique index for dashboard_org_id_folder_uid_title_is_folder','CREATE UNIQUE INDEX `UQE_dashboard_org_id_folder_uid_title_is_folder` ON `dashboard` (`org_id`,`folder_uid`,`title`,`is_folder`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(571,'Restore index for dashboard_org_id_folder_id_title','CREATE INDEX `IDX_dashboard_org_id_folder_id_title` ON `dashboard` (`org_id`,`folder_id`,`title`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(572,'Remove unique index for dashboard_org_id_folder_uid_title_is_folder','DROP INDEX `UQE_dashboard_org_id_folder_uid_title_is_folder`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(573,'create sso_setting table',replace('CREATE TABLE IF NOT EXISTS `sso_setting` (\n`id` TEXT PRIMARY KEY NOT NULL\n, `provider` TEXT NOT NULL\n, `settings` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n, `is_deleted` INTEGER NOT NULL DEFAULT 0\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(574,'copy kvstore migration status to each org','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(575,'add back entry for orgid=0 migrated status','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(576,'managed dashboard permissions annotation actions migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(577,'create cloud_migration table v1',replace('CREATE TABLE IF NOT EXISTS `cloud_migration` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `auth_token` TEXT NULL\n, `stack` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(578,'create cloud_migration_run table v1',replace('CREATE TABLE IF NOT EXISTS `cloud_migration_run` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `cloud_migration_uid` TEXT NULL\n, `result` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n, `finished` DATETIME NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(579,'add stack_id column','alter table `cloud_migration` ADD COLUMN `stack_id` INTEGER NOT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(580,'add region_slug column','alter table `cloud_migration` ADD COLUMN `region_slug` TEXT NOT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(581,'add cluster_slug column','alter table `cloud_migration` ADD COLUMN `cluster_slug` TEXT NOT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(582,'add migration uid column','alter table `cloud_migration` ADD COLUMN `uid` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(583,'Update uid column values for migration','UPDATE cloud_migration SET uid=printf(''u%09d'',id) WHERE uid IS NULL;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(584,'Add unique index migration_uid','CREATE UNIQUE INDEX `UQE_cloud_migration_uid` ON `cloud_migration` (`uid`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(585,'add migration run uid column','alter table `cloud_migration_run` ADD COLUMN `uid` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(586,'Update uid column values for migration run','UPDATE cloud_migration_run SET uid=printf(''u%09d'',id) WHERE uid IS NULL;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(587,'Add unique index migration_run_uid','CREATE UNIQUE INDEX `UQE_cloud_migration_run_uid` ON `cloud_migration_run` (`uid`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(588,'Rename table cloud_migration to cloud_migration_session_tmp_qwerty - v1','ALTER TABLE `cloud_migration` RENAME TO `cloud_migration_session_tmp_qwerty`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(589,'create cloud_migration_session v2',replace('CREATE TABLE IF NOT EXISTS `cloud_migration_session` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `uid` TEXT NULL\n, `auth_token` TEXT NULL\n, `slug` TEXT NOT NULL\n, `stack_id` INTEGER NOT NULL\n, `region_slug` TEXT NOT NULL\n, `cluster_slug` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(590,'create index UQE_cloud_migration_session_uid - v2','CREATE UNIQUE INDEX `UQE_cloud_migration_session_uid` ON `cloud_migration_session` (`uid`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(591,'copy cloud_migration_session v1 to v2',replace('INSERT INTO `cloud_migration_session` (`uid`\n, `auth_token`\n, `slug`\n, `stack_id`\n, `updated`\n, `id`\n, `region_slug`\n, `cluster_slug`\n, `created`) SELECT `uid`\n, `auth_token`\n, `stack`\n, `stack_id`\n, `updated`\n, `id`\n, `region_slug`\n, `cluster_slug`\n, `created` FROM `cloud_migration_session_tmp_qwerty`','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(592,'drop cloud_migration_session_tmp_qwerty','DROP TABLE IF EXISTS `cloud_migration_session_tmp_qwerty`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(593,'Rename table cloud_migration_run to cloud_migration_snapshot_tmp_qwerty - v1','ALTER TABLE `cloud_migration_run` RENAME TO `cloud_migration_snapshot_tmp_qwerty`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(594,'create cloud_migration_snapshot v2',replace('CREATE TABLE IF NOT EXISTS `cloud_migration_snapshot` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `uid` TEXT NULL\n, `session_uid` TEXT NULL\n, `result` TEXT NOT NULL\n, `created` DATETIME NOT NULL\n, `updated` DATETIME NOT NULL\n, `finished` DATETIME NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(595,'create index UQE_cloud_migration_snapshot_uid - v2','CREATE UNIQUE INDEX `UQE_cloud_migration_snapshot_uid` ON `cloud_migration_snapshot` (`uid`);',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(596,'copy cloud_migration_snapshot v1 to v2',replace('INSERT INTO `cloud_migration_snapshot` (`id`\n, `uid`\n, `session_uid`\n, `result`\n, `created`\n, `updated`\n, `finished`) SELECT `id`\n, `uid`\n, `cloud_migration_uid`\n, `result`\n, `created`\n, `updated`\n, `finished` FROM `cloud_migration_snapshot_tmp_qwerty`','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(597,'drop cloud_migration_snapshot_tmp_qwerty','DROP TABLE IF EXISTS `cloud_migration_snapshot_tmp_qwerty`',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(598,'add snapshot upload_url column','alter table `cloud_migration_snapshot` ADD COLUMN `upload_url` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(599,'add snapshot status column','alter table `cloud_migration_snapshot` ADD COLUMN `status` TEXT NOT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(600,'add snapshot local_directory column','alter table `cloud_migration_snapshot` ADD COLUMN `local_directory` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(601,'add snapshot gms_snapshot_uid column','alter table `cloud_migration_snapshot` ADD COLUMN `gms_snapshot_uid` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(602,'add snapshot encryption_key column','alter table `cloud_migration_snapshot` ADD COLUMN `encryption_key` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(603,'add snapshot error_string column','alter table `cloud_migration_snapshot` ADD COLUMN `error_string` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(604,'create cloud_migration_resource table v1',replace('CREATE TABLE IF NOT EXISTS `cloud_migration_resource` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `uid` TEXT NOT NULL\n, `resource_type` TEXT NOT NULL\n, `resource_uid` TEXT NOT NULL\n, `status` TEXT NOT NULL\n, `error_string` TEXT NULL\n, `snapshot_uid` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(605,'delete cloud_migration_snapshot.result column','ALTER TABLE cloud_migration_snapshot DROP COLUMN result',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(606,'add cloud_migration_resource.name column','alter table `cloud_migration_resource` ADD COLUMN `name` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(607,'add cloud_migration_resource.parent_name column','alter table `cloud_migration_resource` ADD COLUMN `parent_name` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(608,'add cloud_migration_session.org_id column','alter table `cloud_migration_session` ADD COLUMN `org_id` INTEGER NOT NULL DEFAULT 1 ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(609,'add cloud_migration_resource.error_code column','alter table `cloud_migration_resource` ADD COLUMN `error_code` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(610,'increase resource_uid column length','SELECT 0;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(611,'alter kv_store.value to longtext','SELECT 0;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(612,'add notification_settings column to alert_rule table','alter table `alert_rule` ADD COLUMN `notification_settings` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(613,'add notification_settings column to alert_rule_version table','alter table `alert_rule_version` ADD COLUMN `notification_settings` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(614,'removing scope from alert.instances:read action migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(615,'managed folder permissions alerting silences actions migration','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(616,'add record column to alert_rule table','alter table `alert_rule` ADD COLUMN `record` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(617,'add record column to alert_rule_version table','alter table `alert_rule_version` ADD COLUMN `record` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(618,'add resolved_at column to alert_instance table','alter table `alert_instance` ADD COLUMN `resolved_at` INTEGER NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(619,'add last_sent_at column to alert_instance table','alter table `alert_instance` ADD COLUMN `last_sent_at` INTEGER NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(620,'Enable traceQL streaming for all Tempo datasources','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(621,'Add scope to alert.notifications.receivers:read and alert.notifications.receivers.secrets:read','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(622,'add metadata column to alert_rule table','alter table `alert_rule` ADD COLUMN `metadata` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(623,'add metadata column to alert_rule_version table','alter table `alert_rule_version` ADD COLUMN `metadata` TEXT NULL ',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(624,'delete orphaned service account permissions','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(625,'adding action set permissions','code migration',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(626,'create user_external_session table',replace('CREATE TABLE IF NOT EXISTS `user_external_session` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `user_auth_id` INTEGER NOT NULL\n, `user_id` INTEGER NOT NULL\n, `auth_module` TEXT NOT NULL\n, `access_token` TEXT NULL\n, `id_token` TEXT NULL\n, `refresh_token` TEXT NULL\n, `session_id` TEXT NULL\n, `session_id_hash` TEXT NULL\n, `name_id` TEXT NULL\n, `name_id_hash` TEXT NULL\n, `expires_at` DATETIME NULL\n, `created_at` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(627,'increase name_id column length to 1024','SELECT 0;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(628,'increase session_id column length to 1024','SELECT 0;',1,'','2025-05-23 21:43:14');
INSERT INTO migration_log VALUES(629,'remove scope from alert.notifications.receivers:create','code migration',1,'','2025-05-23 21:43:14');
CREATE TABLE `user` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `version` INTEGER NOT NULL
, `login` TEXT NOT NULL
, `email` TEXT NOT NULL
, `name` TEXT NULL
, `password` TEXT NULL
, `salt` TEXT NULL
, `rands` TEXT NULL
, `company` TEXT NULL
, `org_id` INTEGER NOT NULL
, `is_admin` INTEGER NOT NULL
, `email_verified` INTEGER NULL
, `theme` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `help_flags1` INTEGER NOT NULL DEFAULT 0, `last_seen_at` DATETIME NULL, `is_disabled` INTEGER NOT NULL DEFAULT 0, is_service_account BOOLEAN DEFAULT 0, `uid` TEXT NULL);
INSERT INTO user VALUES(1,0,'admin','admin@localhost','','d7eeb0030515e2fb7a4264bb9a8a4b170368852ae5b0ac53839c59f027332ccfd168dea04c21a79de2eb77c8ba2c9df2fb75','4Bk0lOCH6V','wtdtTsvDg0','',1,1,0,'','2025-05-23 21:43:14','2025-05-23 21:43:14',0,'2025-05-23 21:53:53',0,0,'cemsh2r65q03kb');
CREATE TABLE `temp_user` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `version` INTEGER NOT NULL
, `email` TEXT NOT NULL
, `name` TEXT NULL
, `role` TEXT NULL
, `code` TEXT NOT NULL
, `status` TEXT NOT NULL
, `invited_by_user_id` INTEGER NULL
, `email_sent` INTEGER NOT NULL
, `email_sent_on` DATETIME NULL
, `remote_addr` TEXT NULL
, `created` INTEGER NOT NULL DEFAULT 0
, `updated` INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE `star` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `user_id` INTEGER NOT NULL
, `dashboard_id` INTEGER NOT NULL
, `dashboard_uid` TEXT NULL, `org_id` INTEGER NULL DEFAULT 1, `updated` DATETIME NULL);
CREATE TABLE `org` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `version` INTEGER NOT NULL
, `name` TEXT NOT NULL
, `address1` TEXT NULL
, `address2` TEXT NULL
, `city` TEXT NULL
, `state` TEXT NULL
, `zip_code` TEXT NULL
, `country` TEXT NULL
, `billing_email` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO org VALUES(1,0,'Main Org.','','','','','','',NULL,'2025-05-23 21:43:14','2025-05-23 21:43:14');
CREATE TABLE `org_user` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `role` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO org_user VALUES(1,1,1,'Admin','2025-05-23 21:43:15','2025-05-23 21:43:15');
CREATE TABLE `dashboard_tag` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `dashboard_id` INTEGER NOT NULL
, `term` TEXT NOT NULL
, `dashboard_uid` TEXT NULL, `org_id` INTEGER NULL DEFAULT 1);
CREATE TABLE `dashboard` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `version` INTEGER NOT NULL
, `slug` TEXT NOT NULL
, `title` TEXT NOT NULL
, `data` TEXT NOT NULL
, `org_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `updated_by` INTEGER NULL, `created_by` INTEGER NULL, `gnet_id` INTEGER NULL, `plugin_id` TEXT NULL, `folder_id` INTEGER NOT NULL DEFAULT 0, `is_folder` INTEGER NOT NULL DEFAULT 0, `has_acl` INTEGER NOT NULL DEFAULT 0, `uid` TEXT NULL, `is_public` INTEGER NOT NULL DEFAULT 0, `deleted` DATETIME NULL, `folder_uid` TEXT NULL);
INSERT INTO dashboard VALUES(1,2,'redis-high-level-kpi-dashboard','Redis High-Level KPI Dashboard',X'7b22616e6e6f746174696f6e73223a7b226c697374223a5b7b226275696c74496e223a312c2264617461736f75726365223a7b2274797065223a2267726166616e61222c22756964223a222d2d2047726166616e61202d2d227d2c22656e61626c65223a747275652c2268696465223a747275652c2269636f6e436f6c6f72223a227267626128302c203231312c203235352c203129222c226e616d65223a22416e6e6f746174696f6e73205c753030323620416c65727473222c2274797065223a2264617368626f617264227d5d7d2c226564697461626c65223a747275652c2266697363616c5965617253746172744d6f6e7468223a302c226772617068546f6f6c746970223a302c226964223a312c226c696e6b73223a5b5d2c2270616e656c73223a5b7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a2261656d7369363970777a736f7765227d2c226669656c64436f6e666967223a7b2264656661756c7473223a7b22636f6c6f72223a7b226d6f6465223a2270616c657474652d636c6173736963227d2c22637573746f6d223a7b2261786973426f7264657253686f77223a66616c73652c226178697343656e74657265645a65726f223a66616c73652c2261786973436f6c6f724d6f6465223a2274657874222c22617869734c6162656c223a22222c2261786973506c6163656d656e74223a226175746f222c22626172416c69676e6d656e74223a302c226261725769647468466163746f72223a302e362c22647261775374796c65223a226c696e65222c2266696c6c4f706163697479223a302c226772616469656e744d6f6465223a226e6f6e65222c226869646546726f6d223a7b226c6567656e64223a66616c73652c22746f6f6c746970223a66616c73652c2276697a223a66616c73657d2c22696e736572744e756c6c73223a66616c73652c226c696e65496e746572706f6c6174696f6e223a226c696e656172222c226c696e655769647468223a342c22706f696e7453697a65223a352c227363616c65446973747269627574696f6e223a7b2274797065223a226c696e656172227d2c2273686f77506f696e7473223a226175746f222c227370616e4e756c6c73223a66616c73652c22737461636b696e67223a7b2267726f7570223a2241222c226d6f6465223a226e6f6e65227d2c227468726573686f6c64735374796c65223a7b226d6f6465223a226f6666227d7d2c226d617070696e6773223a5b5d2c227468726573686f6c6473223a7b226d6f6465223a226162736f6c757465222c227374657073223a5b7b22636f6c6f72223a22677265656e222c2276616c7565223a6e756c6c7d2c7b22636f6c6f72223a22726564222c2276616c7565223a38307d5d7d7d2c226f7665727269646573223a5b5d7d2c2267726964506f73223a7b2268223a31322c2277223a32342c2278223a302c2279223a307d2c226964223a342c226f7074696f6e73223a7b226c6567656e64223a7b2263616c6373223a5b226c6173744e6f744e756c6c222c2266697273744e6f744e756c6c222c226d6178222c226d65616e225d2c22646973706c61794d6f6465223a227461626c65222c22706c6163656d656e74223a22626f74746f6d222c2273686f774c6567656e64223a747275657d2c22746f6f6c746970223a7b22686964655a65726f73223a66616c73652c226d6f6465223a2273696e676c65222c22736f7274223a226e6f6e65227d7d2c22706c7567696e56657273696f6e223a2231312e352e32222c2274617267657473223a5b7b2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a226275696c646572222c2265787072223a2272656469735f636f6e6e65637465645f636c69656e74737b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c2266756c6c4d657461536561726368223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c226c6567656e64466f726d6174223a2272656469735f636f6e6e65637465645f636c69656e7473222c2272616e6765223a747275652c227265664964223a2241222c227573654261636b656e64223a66616c73657d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a226275696c646572222c2265787072223a2272656469735f657669637465645f6b6579737b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c2266756c6c4d657461536561726368223a66616c73652c2268696465223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c22696e7374616e74223a66616c73652c226c6567656e64466f726d6174223a2272656469735f657669637465645f6b657973222c2272616e6765223a747275652c227265664964223a2242222c227573654261636b656e64223a66616c73657d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a22636f6465222c226578656d706c6172223a66616c73652c2265787072223a2272656469735f657870697265645f6b6579737b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c22666f726d6174223a2274696d655f736572696573222c2266756c6c4d657461536561726368223a66616c73652c2268696465223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c22696e7374616e74223a66616c73652c22696e74657276616c223a22222c226c6567656e64466f726d6174223a2272656469735f657870697265645f6b657973222c2272616e6765223a747275652c227265664964223a2243222c227573654261636b656e64223a66616c73657d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a226275696c646572222c2265787072223a2272656469735f6c6174656e63795f7365636f6e64737b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c2266756c6c4d657461536561726368223a66616c73652c2268696465223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c22696e7374616e74223a66616c73652c226c6567656e64466f726d6174223a2272656469735f6c6174656e6379222c2272616e6765223a747275652c227265664964223a2244222c227573654261636b656e64223a66616c73657d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a226275696c646572222c2265787072223a2272656469735f7265706c69636174696f6e5f6c61677b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c2266756c6c4d657461536561726368223a66616c73652c2268696465223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c22696e7374616e74223a66616c73652c226c6567656e64466f726d6174223a2272656469735f7265706c69636174696f6e5f6c6167222c2272616e6765223a747275652c227265664964223a2245222c227573654261636b656e64223a66616c73657d5d2c227469746c65223a2253797374656d204865616c74682053756d6d617279222c2274797065223a2274696d65736572696573227d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c226669656c64436f6e666967223a7b2264656661756c7473223a7b22636f6c6f72223a7b226d6f6465223a2270616c657474652d636c6173736963227d2c22637573746f6d223a7b2261786973426f7264657253686f77223a747275652c226178697343656e74657265645a65726f223a66616c73652c2261786973436f6c6f724d6f6465223a2274657874222c22617869734c6162656c223a224f707320706572207365636f6e64222c2261786973506c6163656d656e74223a226175746f222c22626172416c69676e6d656e74223a312c226261725769647468466163746f72223a302e332c22647261775374796c65223a226c696e65222c2266696c6c4f706163697479223a302c226772616469656e744d6f6465223a226e6f6e65222c226869646546726f6d223a7b226c6567656e64223a66616c73652c22746f6f6c746970223a66616c73652c2276697a223a66616c73657d2c22696e736572744e756c6c73223a66616c73652c226c696e65496e746572706f6c6174696f6e223a22737465704265666f7265222c226c696e655769647468223a342c22706f696e7453697a65223a352c227363616c65446973747269627574696f6e223a7b2274797065223a226c696e656172227d2c2273686f77506f696e7473223a226175746f222c227370616e4e756c6c73223a66616c73652c22737461636b696e67223a7b2267726f7570223a2241222c226d6f6465223a226e6f6e65227d2c227468726573686f6c64735374796c65223a7b226d6f6465223a226f6666227d7d2c226d617070696e6773223a5b5d2c227468726573686f6c6473223a7b226d6f6465223a226162736f6c757465222c227374657073223a5b7b22636f6c6f72223a22677265656e222c2276616c7565223a6e756c6c7d2c7b22636f6c6f72223a22726564222c2276616c7565223a38307d5d7d7d2c226f7665727269646573223a5b5d7d2c2267726964506f73223a7b2268223a392c2277223a31322c2278223a302c2279223a31327d2c226964223a332c226f7074696f6e73223a7b226c6567656e64223a7b2263616c6373223a5b226c6173744e6f744e756c6c222c226d696e222c226d6178222c226d65616e225d2c22646973706c61794d6f6465223a227461626c65222c22706c6163656d656e74223a22626f74746f6d222c2273686f774c6567656e64223a747275657d2c22746f6f6c746970223a7b22686964655a65726f73223a66616c73652c226d6f6465223a2273696e676c65222c22736f7274223a226e6f6e65227d7d2c22706c7567696e56657273696f6e223a2231312e352e32222c2274617267657473223a5b7b2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a226275696c646572222c2265787072223a2272656469735f696e7374616e74616e656f75735f6f70735f7065725f7365637b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c2266756c6c4d657461536561726368223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c226c6567656e64466f726d6174223a2272656469732d696e7374616e74616e656f732d6f70732d7065722d736563222c2272616e6765223a747275652c227265664964223a2241222c227573654261636b656e64223a66616c73657d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a226275696c646572222c2265787072223a2272656469735f746f74616c5f636f6d6d616e64735f70726f6365737365647b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c2266756c6c4d657461536561726368223a66616c73652c2268696465223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c22696e7374616e74223a66616c73652c226c6567656e64466f726d6174223a2272656469732d746f74616c2d636f6d6d616e64732d70726f636573736564222c2272616e6765223a747275652c227265664964223a2242222c227573654261636b656e64223a66616c73657d5d2c227469746c65223a225468726f756768707574204f76657276696577222c2274797065223a2274696d65736572696573227d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c226669656c64436f6e666967223a7b2264656661756c7473223a7b22636f6c6f72223a7b226d6f6465223a2270616c657474652d636c61737369632d62792d6e616d65227d2c22637573746f6d223a7b2261786973426f7264657253686f77223a66616c73652c226178697343656e74657265645a65726f223a66616c73652c2261786973436f6c6f724d6f6465223a2274657874222c22617869734772696453686f77223a747275652c22617869734c6162656c223a22222c2261786973506c6163656d656e74223a226c656674222c22626172416c69676e6d656e74223a302c226261725769647468466163746f72223a302e362c22647261775374796c65223a226c696e65222c2266696c6c4f706163697479223a302c226772616469656e744d6f6465223a226e6f6e65222c226869646546726f6d223a7b226c6567656e64223a66616c73652c22746f6f6c746970223a66616c73652c2276697a223a66616c73657d2c22696e736572744e756c6c73223a66616c73652c226c696e65496e746572706f6c6174696f6e223a226c696e656172222c226c696e655374796c65223a7b2266696c6c223a22736f6c6964227d2c226c696e655769647468223a342c22706f696e7453697a65223a352c227363616c65446973747269627574696f6e223a7b2274797065223a226c696e656172227d2c2273686f77506f696e7473223a22616c77617973222c227370616e4e756c6c73223a66616c73652c22737461636b696e67223a7b2267726f7570223a2241222c226d6f6465223a226e6f6e65227d2c227468726573686f6c64735374796c65223a7b226d6f6465223a226f6666227d7d2c226669656c644d696e4d6178223a66616c73652c226d617070696e6773223a5b5d2c226d696e223a302c227468726573686f6c6473223a7b226d6f6465223a226162736f6c757465222c227374657073223a5b7b22636f6c6f72223a22677265656e222c2276616c7565223a6e756c6c7d2c7b22636f6c6f72223a22726564222c2276616c7565223a38307d5d7d2c22756e6974223a226465636d6279746573227d2c226f7665727269646573223a5b5d7d2c2267726964506f73223a7b2268223a392c2277223a31322c2278223a31322c2279223a31327d2c226964223a322c226f7074696f6e73223a7b226c6567656e64223a7b2263616c6373223a5b226c617374222c226d696e222c226d6178222c226d65616e225d2c22646973706c61794d6f6465223a227461626c65222c22706c6163656d656e74223a22626f74746f6d222c2273686f774c6567656e64223a747275657d2c22746f6f6c746970223a7b22686964655a65726f73223a66616c73652c226d6f6465223a226e6f6e65222c22736f7274223a226e6f6e65227d7d2c22706c7567696e56657273696f6e223a2231312e352e32222c2274617267657473223a5b7b2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a22636f6465222c2265787072223a2272656469735f6d656d6f72795f75736167655f6279746573202f2031303030303030222c2266756c6c4d657461536561726368223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c226c6567656e64466f726d6174223a2272656469732d6d656d6f72792d75736167652d696e2d6279746573222c2272616e6765223a747275652c227265664964223a2241222c227573654261636b656e64223a66616c73657d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a22636f6465222c2265787072223a2272656469735f7273735f6d656d6f72795f75736167655f6279746573202f2031303030303030222c2266756c6c4d657461536561726368223a66616c73652c2268696465223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c22696e7374616e74223a66616c73652c226c6567656e64466f726d6174223a2272656469732d7273732d6d656d6f72792d75736167652d696e2d6279746573222c2272616e6765223a747275652c227265664964223a2242222c227573654261636b656e64223a66616c73657d5d2c227469746c65223a224d656d6f7279205573616765204f76657276696577222c2274797065223a2274696d65736572696573227d2c7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c226669656c64436f6e666967223a7b2264656661756c7473223a7b22636f6c6f72223a7b226d6f6465223a227468726573686f6c6473227d2c22646563696d616c73223a312c22646973706c61794e616d65223a2243757272656e74204361636865204869742052617465222c226669656c644d696e4d6178223a66616c73652c226d617070696e6773223a5b5d2c226d6178223a312c226d696e223a302c227468726573686f6c6473223a7b226d6f6465223a226162736f6c757465222c227374657073223a5b7b22636f6c6f72223a227472616e73706172656e74222c2276616c7565223a6e756c6c7d2c7b22636f6c6f72223a226461726b2d726564222c2276616c7565223a307d2c7b22636f6c6f72223a226461726b2d726564222c2276616c7565223a302e357d2c7b22636f6c6f72223a2223454142383339222c2276616c7565223a302e377d2c7b22636f6c6f72223a22677265656e222c2276616c7565223a302e397d5d7d2c22756e6974223a226e6f6e65227d2c226f7665727269646573223a5b5d7d2c2267726964506f73223a7b2268223a382c2277223a32342c2278223a302c2279223a32317d2c226964223a312c226f7074696f6e73223a7b226d696e56697a486569676874223a312c226d696e56697a5769647468223a37352c226f7269656e746174696f6e223a22686f72697a6f6e74616c222c227265647563654f7074696f6e73223a7b2263616c6373223a5b226c6173744e6f744e756c6c225d2c226669656c6473223a22222c2276616c756573223a66616c73657d2c2273686f775468726573686f6c644c6162656c73223a66616c73652c2273686f775468726573686f6c644d61726b657273223a747275652c2273697a696e67223a226175746f222c2274657874223a7b7d7d2c22706c7567696e56657273696f6e223a2231312e352e32222c2274617267657473223a5b7b2264617461736f75726365223a7b2274797065223a2270726f6d657468657573222c22756964223a22616564797777697a313234673061227d2c2264697361626c655465787457726170223a66616c73652c22656469746f724d6f6465223a226275696c646572222c2265787072223a2272656469735f63616368655f6869745f726174657b6a6f623d5c22637573746f6d2d6578706f727465725c227d222c2266756c6c4d657461536561726368223a66616c73652c22696e636c7564654e756c6c4d65746164617461223a747275652c226c6567656e64466f726d6174223a225f5f6175746f222c2272616e6765223a747275652c227265664964223a2241222c227573654261636b656e64223a66616c73657d5d2c227469746c65223a224361636865204869742052617465222c2274797065223a226761756765227d5d2c227072656c6f6164223a66616c73652c2272656672657368223a223573222c22736368656d6156657273696f6e223a34302c2274616773223a5b5d2c2274656d706c6174696e67223a7b226c697374223a5b5d7d2c2274696d65223a7b2266726f6d223a226e6f772d356d222c22746f223a226e6f77227d2c2274696d657069636b6572223a7b7d2c2274696d657a6f6e65223a2262726f77736572222c227469746c65223a22526564697320486967682d4c6576656c204b50492044617368626f617264222c22756964223a2262656672307939776c736f687362222c2276657273696f6e223a322c227765656b5374617274223a22227d',1,'2025-05-23 21:55:19','2025-05-23 21:55:58',1,1,0,'',0,0,0,'befr0y9wlsohsb',0,NULL,NULL);
INSERT INTO dashboard VALUES(2,1,'kubernetes-pod-health-and-resource-usage','Kubernetes Pod Health & Resource Usage','{"annotations":{"list":[{"builtIn":1,"datasource":{"type":"grafana","uid":"-- Grafana --"},"enable":true,"hide":true,"iconColor":"rgba(0, 211, 255, 1)","name":"Annotations \u0026 Alerts","type":"dashboard"}]},"editable":true,"fiscalYearStartMonth":0,"graphTooltip":0,"id":null,"links":[],"panels":[{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"thresholds"},"mappings":[{"options":{"-1":{"color":"dark-red","index":2,"text":"Failed"},"0":{"color":"yellow","index":1,"text":"Pending"},"1":{"color":"green","index":0,"text":"Running"}},"type":"value"}],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null}]}},"overrides":[]},"gridPos":{"h":3,"w":24,"x":0,"y":0},"id":3,"options":{"colorMode":"value","graphMode":"none","justifyMode":"center","orientation":"auto","percentChangeColorMode":"same_as_value","reduceOptions":{"calcs":["lastNotNull"],"fields":"","values":false},"showPercentChange":false,"text":{},"textMode":"value_and_name","wideLayout":true},"pluginVersion":"11.5.2","targets":[{"editorMode":"code","expr":"sum by (pod, namespace) (pod_status)\r\n","legendFormat":"{{pod}}","range":true,"refId":"A"}],"title":"Pod Status","type":"stat"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"","axisPlacement":"auto","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]},"unit":"decmbytes"},"overrides":[]},"gridPos":{"h":8,"w":24,"x":0,"y":3},"id":2,"options":{"legend":{"calcs":[],"displayMode":"list","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"editorMode":"code","expr":"pod_memory_usage_bytes / 1000000","legendFormat":"{{pod}}","range":true,"refId":"A"}],"title":"Memory Usage per Pod","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"","axisPlacement":"auto","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null}]},"unit":"none"},"overrides":[]},"gridPos":{"h":8,"w":24,"x":0,"y":11},"id":1,"options":{"legend":{"calcs":[],"displayMode":"list","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","exemplar":false,"expr":"pod_cpu_usage_cores * 1000","format":"time_series","fullMetaSearch":false,"includeNullMetadata":true,"instant":false,"interval":"","legendFormat":"{{pod}}","range":true,"refId":"A","useBackend":false}],"title":"CPU Usage per Pod","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"thresholds"},"fieldMinMax":false,"mappings":[],"min":0,"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"#EAB839","value":3},{"color":"red","value":5}]}},"overrides":[]},"gridPos":{"h":6,"w":24,"x":0,"y":19},"id":4,"options":{"minVizHeight":75,"minVizWidth":75,"orientation":"auto","reduceOptions":{"calcs":["lastNotNull"],"fields":"","values":false},"showThresholdLabels":false,"showThresholdMarkers":true,"sizing":"auto"},"pluginVersion":"11.5.2","targets":[{"editorMode":"code","expr":"sum by (pod, namespace) (pod_event_warnings)\r\n","legendFormat":"{{pod}}","range":true,"refId":"A"}],"title":"Warning \u0026 Error Events","type":"gauge"}],"preload":false,"refresh":"1m","schemaVersion":40,"tags":[],"templating":{"list":[]},"time":{"from":"now-1h","to":"now"},"timepicker":{},"timezone":"browser","title":"Kubernetes Pod Health \u0026 Resource Usage","uid":"cegcdx7ggs6ioe","version":1,"weekStart":""}',1,'2025-05-23 21:55:25','2025-05-23 21:55:25',1,1,0,'',0,0,0,'cegcdx7ggs6ioe',0,NULL,NULL);
INSERT INTO dashboard VALUES(3,1,'alerts','Alerts','{"schemaVersion":17,"title":"Alerts","uid":"eemsi9qgyfpc0e","version":1}',1,'2025-05-23 21:56:41','2025-05-23 21:56:41',1,1,0,'',0,1,0,'eemsi9qgyfpc0e',0,NULL,NULL);
CREATE TABLE `dashboard_provisioning` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `dashboard_id` INTEGER NULL
, `name` TEXT NOT NULL
, `external_id` TEXT NOT NULL
, `updated` INTEGER NOT NULL DEFAULT 0
, `check_sum` TEXT NULL);
CREATE TABLE `data_source` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `version` INTEGER NOT NULL
, `type` TEXT NOT NULL
, `name` TEXT NOT NULL
, `access` TEXT NOT NULL
, `url` TEXT NOT NULL
, `password` TEXT NULL
, `user` TEXT NULL
, `database` TEXT NULL
, `basic_auth` INTEGER NOT NULL
, `basic_auth_user` TEXT NULL
, `basic_auth_password` TEXT NULL
, `is_default` INTEGER NOT NULL
, `json_data` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `with_credentials` INTEGER NOT NULL DEFAULT 0, `secure_json_data` TEXT NULL, `read_only` INTEGER NULL, `uid` TEXT NOT NULL DEFAULT 0, `is_prunable` INTEGER NULL DEFAULT 0, `api_version` TEXT NULL);
INSERT INTO data_source VALUES(1,1,2,'prometheus','prometheus','proxy','http://prometheus-server.default','','','',0,'','',1,X'7b22687474704d6574686f64223a22504f5354227d','2025-05-23 21:55:36','2025-05-23 21:55:44',0,'{}',0,'aemsi69pwzsowe',0,'');
CREATE TABLE `api_key` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `name` TEXT NOT NULL
, `key` TEXT NOT NULL
, `role` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `expires` INTEGER NULL, `service_account_id` INTEGER NULL, `last_used_at` DATETIME NULL, `is_revoked` INTEGER NULL DEFAULT 0);
CREATE TABLE `dashboard_snapshot` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `key` TEXT NOT NULL
, `delete_key` TEXT NOT NULL
, `org_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `external` INTEGER NOT NULL
, `external_url` TEXT NOT NULL
, `dashboard` TEXT NOT NULL
, `expires` DATETIME NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `external_delete_url` TEXT NULL, `dashboard_encrypted` BLOB NULL);
CREATE TABLE `quota` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NULL
, `user_id` INTEGER NULL
, `target` TEXT NOT NULL
, `limit` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
CREATE TABLE IF NOT EXISTS "plugin_setting" (
			"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
			"org_id" INTEGER NOT NULL DEFAULT 1,
			"plugin_id" TEXT NOT NULL,
			"enabled" INTEGER NOT NULL,
			"pinned" INTEGER NOT NULL,
			"json_data" TEXT NULL,
			"secure_json_data" TEXT NULL,
			"created" DATETIME NOT NULL,
			"updated" DATETIME NOT NULL,
			"plugin_version" TEXT NULL);
CREATE TABLE `session` (
`key` TEXT PRIMARY KEY NOT NULL
, `data` BLOB NOT NULL
, `expiry` INTEGER NOT NULL
);
CREATE TABLE `playlist` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `interval` TEXT NOT NULL
, `org_id` INTEGER NOT NULL
, `created_at` INTEGER NOT NULL DEFAULT 0, `updated_at` INTEGER NOT NULL DEFAULT 0, `uid` TEXT NOT NULL DEFAULT 0);
CREATE TABLE `playlist_item` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `playlist_id` INTEGER NOT NULL
, `type` TEXT NOT NULL
, `value` TEXT NOT NULL
, `title` TEXT NOT NULL
, `order` INTEGER NOT NULL
);
CREATE TABLE `preferences` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `version` INTEGER NOT NULL
, `home_dashboard_id` INTEGER NOT NULL
, `timezone` TEXT NOT NULL
, `theme` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `team_id` INTEGER NULL, `week_start` TEXT NULL, `json_data` TEXT NULL);
CREATE TABLE `alert` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `version` INTEGER NOT NULL
, `dashboard_id` INTEGER NOT NULL
, `panel_id` INTEGER NOT NULL
, `org_id` INTEGER NOT NULL
, `name` TEXT NOT NULL
, `message` TEXT NOT NULL
, `state` TEXT NOT NULL
, `settings` TEXT NOT NULL
, `frequency` INTEGER NOT NULL
, `handler` INTEGER NOT NULL
, `severity` TEXT NOT NULL
, `silenced` INTEGER NOT NULL
, `execution_error` TEXT NOT NULL
, `eval_data` TEXT NULL
, `eval_date` DATETIME NULL
, `new_state_date` DATETIME NOT NULL
, `state_changes` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `for` INTEGER NULL);
CREATE TABLE `alert_rule_tag` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `alert_id` INTEGER NOT NULL
, `tag_id` INTEGER NOT NULL
);
CREATE TABLE `alert_notification` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `name` TEXT NOT NULL
, `type` TEXT NOT NULL
, `settings` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `is_default` INTEGER NOT NULL DEFAULT 0, `frequency` INTEGER NULL, `send_reminder` INTEGER NULL DEFAULT 0, `disable_resolve_message` INTEGER NOT NULL DEFAULT 0, `uid` TEXT NULL, `secure_settings` TEXT NULL);
CREATE TABLE `alert_notification_state` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `alert_id` INTEGER NOT NULL
, `notifier_id` INTEGER NOT NULL
, `state` TEXT NOT NULL
, `version` INTEGER NOT NULL
, `updated_at` INTEGER NOT NULL
, `alert_rule_state_updated_version` INTEGER NOT NULL
);
CREATE TABLE `annotation` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `alert_id` INTEGER NULL
, `user_id` INTEGER NULL
, `dashboard_id` INTEGER NULL
, `panel_id` INTEGER NULL
, `category_id` INTEGER NULL
, `type` TEXT NOT NULL
, `title` TEXT NOT NULL
, `text` TEXT NOT NULL
, `metric` TEXT NULL
, `prev_state` TEXT NOT NULL
, `new_state` TEXT NOT NULL
, `data` TEXT NOT NULL
, `epoch` INTEGER NOT NULL
, `region_id` INTEGER NULL DEFAULT 0, `tags` TEXT NULL, `created` INTEGER NULL DEFAULT 0, `updated` INTEGER NULL DEFAULT 0, `epoch_end` INTEGER NOT NULL DEFAULT 0);
INSERT INTO annotation VALUES(1,1,2,0,0,0,NULL,'','','redis cache is under critical threshold {alertname=redis cache is under critical threshold, grafana_folder=Alerts, instance=custom-exporter-service.default:2112, job=custom-exporter} - A=0.000000, C=1.000000',NULL,'Normal','Pending','{"values":{"A":0,"C":1}}',1748037790000,0,'[]',1748037790012,1748037790012,1748037790000);
CREATE TABLE `annotation_tag` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `annotation_id` INTEGER NOT NULL
, `tag_id` INTEGER NOT NULL
);
CREATE TABLE `test_data` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `metric1` TEXT NULL
, `metric2` TEXT NULL
, `value_big_int` INTEGER NULL
, `value_double` REAL NULL
, `value_float` REAL NULL
, `value_int` INTEGER NULL
, `time_epoch` INTEGER NOT NULL
, `time_date_time` DATETIME NOT NULL
, `time_time_stamp` DATETIME NOT NULL
);
CREATE TABLE `dashboard_version` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `dashboard_id` INTEGER NOT NULL
, `parent_version` INTEGER NOT NULL
, `restored_from` INTEGER NOT NULL
, `version` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `created_by` INTEGER NOT NULL
, `message` TEXT NOT NULL
, `data` TEXT NOT NULL
);
INSERT INTO dashboard_version VALUES(1,1,13,0,1,'2025-05-23 21:55:19',1,'','{"annotations":{"list":[{"builtIn":1,"datasource":{"type":"grafana","uid":"-- Grafana --"},"enable":true,"hide":true,"iconColor":"rgba(0, 211, 255, 1)","name":"Annotations \u0026 Alerts","type":"dashboard"}]},"editable":true,"fiscalYearStartMonth":0,"graphTooltip":0,"id":null,"links":[],"panels":[{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"","axisPlacement":"auto","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]}},"overrides":[]},"gridPos":{"h":12,"w":24,"x":0,"y":0},"id":4,"options":{"legend":{"calcs":["lastNotNull","firstNotNull","max","mean"],"displayMode":"table","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"disableTextWrap":false,"editorMode":"builder","expr":"redis_connected_clients{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"redis_connected_clients","range":true,"refId":"A","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_evicted_keys{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis_evicted_keys","range":true,"refId":"B","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"code","exemplar":false,"expr":"redis_expired_keys{job=\"custom-exporter\"}","format":"time_series","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"interval":"","legendFormat":"redis_expired_keys","range":true,"refId":"C","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_latency_seconds{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis_latency","range":true,"refId":"D","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_replication_lag{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis_replication_lag","range":true,"refId":"E","useBackend":false}],"title":"System Health Summary","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":true,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"Ops per second","axisPlacement":"auto","barAlignment":1,"barWidthFactor":0.3,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"stepBefore","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]}},"overrides":[]},"gridPos":{"h":9,"w":12,"x":0,"y":12},"id":3,"options":{"legend":{"calcs":["lastNotNull","min","max","mean"],"displayMode":"table","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"disableTextWrap":false,"editorMode":"builder","expr":"redis_instantaneous_ops_per_sec{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"redis-instantaneos-ops-per-sec","range":true,"refId":"A","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_total_commands_processed{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis-total-commands-processed","range":true,"refId":"B","useBackend":false}],"title":"Throughput Overview","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic-by-name"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisGridShow":true,"axisLabel":"","axisPlacement":"left","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineStyle":{"fill":"solid"},"lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"always","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"fieldMinMax":false,"mappings":[],"min":0,"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]},"unit":"decmbytes"},"overrides":[]},"gridPos":{"h":9,"w":12,"x":12,"y":12},"id":2,"options":{"legend":{"calcs":["last","min","max","mean"],"displayMode":"table","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"none","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"disableTextWrap":false,"editorMode":"code","expr":"redis_memory_usage_bytes / 1000000","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"redis-memory-usage-in-bytes","range":true,"refId":"A","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"code","expr":"redis_rss_memory_usage_bytes / 1000000","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis-rss-memory-usage-in-bytes","range":true,"refId":"B","useBackend":false}],"title":"Memory Usage Overview","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"thresholds"},"decimals":1,"displayName":"Current Cache Hit Rate","fieldMinMax":false,"mappings":[],"max":1,"min":0,"thresholds":{"mode":"absolute","steps":[{"color":"transparent","value":null},{"color":"dark-red","value":0},{"color":"dark-red","value":0.5},{"color":"#EAB839","value":0.7},{"color":"green","value":0.9}]},"unit":"none"},"overrides":[]},"gridPos":{"h":8,"w":24,"x":0,"y":21},"id":1,"options":{"minVizHeight":1,"minVizWidth":75,"orientation":"horizontal","reduceOptions":{"calcs":["lastNotNull"],"fields":"","values":false},"showThresholdLabels":false,"showThresholdMarkers":true,"sizing":"auto","text":{}},"pluginVersion":"11.5.2","targets":[{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_cache_hit_rate{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"__auto","range":true,"refId":"A","useBackend":false}],"title":"Cache Hit Rate","type":"gauge"}],"preload":false,"refresh":"5s","schemaVersion":40,"tags":[],"templating":{"list":[]},"time":{"from":"now-5m","to":"now"},"timepicker":{},"timezone":"browser","title":"Redis High-Level KPI Dashboard","uid":"befr0y9wlsohsb","version":1,"weekStart":""}');
INSERT INTO dashboard_version VALUES(2,2,4,0,1,'2025-05-23 21:55:25',1,'','{"annotations":{"list":[{"builtIn":1,"datasource":{"type":"grafana","uid":"-- Grafana --"},"enable":true,"hide":true,"iconColor":"rgba(0, 211, 255, 1)","name":"Annotations \u0026 Alerts","type":"dashboard"}]},"editable":true,"fiscalYearStartMonth":0,"graphTooltip":0,"id":null,"links":[],"panels":[{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"thresholds"},"mappings":[{"options":{"-1":{"color":"dark-red","index":2,"text":"Failed"},"0":{"color":"yellow","index":1,"text":"Pending"},"1":{"color":"green","index":0,"text":"Running"}},"type":"value"}],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null}]}},"overrides":[]},"gridPos":{"h":3,"w":24,"x":0,"y":0},"id":3,"options":{"colorMode":"value","graphMode":"none","justifyMode":"center","orientation":"auto","percentChangeColorMode":"same_as_value","reduceOptions":{"calcs":["lastNotNull"],"fields":"","values":false},"showPercentChange":false,"text":{},"textMode":"value_and_name","wideLayout":true},"pluginVersion":"11.5.2","targets":[{"editorMode":"code","expr":"sum by (pod, namespace) (pod_status)\r\n","legendFormat":"{{pod}}","range":true,"refId":"A"}],"title":"Pod Status","type":"stat"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"","axisPlacement":"auto","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]},"unit":"decmbytes"},"overrides":[]},"gridPos":{"h":8,"w":24,"x":0,"y":3},"id":2,"options":{"legend":{"calcs":[],"displayMode":"list","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"editorMode":"code","expr":"pod_memory_usage_bytes / 1000000","legendFormat":"{{pod}}","range":true,"refId":"A"}],"title":"Memory Usage per Pod","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"","axisPlacement":"auto","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null}]},"unit":"none"},"overrides":[]},"gridPos":{"h":8,"w":24,"x":0,"y":11},"id":1,"options":{"legend":{"calcs":[],"displayMode":"list","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","exemplar":false,"expr":"pod_cpu_usage_cores * 1000","format":"time_series","fullMetaSearch":false,"includeNullMetadata":true,"instant":false,"interval":"","legendFormat":"{{pod}}","range":true,"refId":"A","useBackend":false}],"title":"CPU Usage per Pod","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"thresholds"},"fieldMinMax":false,"mappings":[],"min":0,"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"#EAB839","value":3},{"color":"red","value":5}]}},"overrides":[]},"gridPos":{"h":6,"w":24,"x":0,"y":19},"id":4,"options":{"minVizHeight":75,"minVizWidth":75,"orientation":"auto","reduceOptions":{"calcs":["lastNotNull"],"fields":"","values":false},"showThresholdLabels":false,"showThresholdMarkers":true,"sizing":"auto"},"pluginVersion":"11.5.2","targets":[{"editorMode":"code","expr":"sum by (pod, namespace) (pod_event_warnings)\r\n","legendFormat":"{{pod}}","range":true,"refId":"A"}],"title":"Warning \u0026 Error Events","type":"gauge"}],"preload":false,"refresh":"1m","schemaVersion":40,"tags":[],"templating":{"list":[]},"time":{"from":"now-1h","to":"now"},"timepicker":{},"timezone":"browser","title":"Kubernetes Pod Health \u0026 Resource Usage","uid":"cegcdx7ggs6ioe","version":1,"weekStart":""}');
INSERT INTO dashboard_version VALUES(3,1,1,0,2,'2025-05-23 21:55:58',1,'','{"annotations":{"list":[{"builtIn":1,"datasource":{"type":"grafana","uid":"-- Grafana --"},"enable":true,"hide":true,"iconColor":"rgba(0, 211, 255, 1)","name":"Annotations \u0026 Alerts","type":"dashboard"}]},"editable":true,"fiscalYearStartMonth":0,"graphTooltip":0,"id":1,"links":[],"panels":[{"datasource":{"type":"prometheus","uid":"aemsi69pwzsowe"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"","axisPlacement":"auto","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]}},"overrides":[]},"gridPos":{"h":12,"w":24,"x":0,"y":0},"id":4,"options":{"legend":{"calcs":["lastNotNull","firstNotNull","max","mean"],"displayMode":"table","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"disableTextWrap":false,"editorMode":"builder","expr":"redis_connected_clients{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"redis_connected_clients","range":true,"refId":"A","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_evicted_keys{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis_evicted_keys","range":true,"refId":"B","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"code","exemplar":false,"expr":"redis_expired_keys{job=\"custom-exporter\"}","format":"time_series","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"interval":"","legendFormat":"redis_expired_keys","range":true,"refId":"C","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_latency_seconds{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis_latency","range":true,"refId":"D","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_replication_lag{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis_replication_lag","range":true,"refId":"E","useBackend":false}],"title":"System Health Summary","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic"},"custom":{"axisBorderShow":true,"axisCenteredZero":false,"axisColorMode":"text","axisLabel":"Ops per second","axisPlacement":"auto","barAlignment":1,"barWidthFactor":0.3,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"stepBefore","lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"auto","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"mappings":[],"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]}},"overrides":[]},"gridPos":{"h":9,"w":12,"x":0,"y":12},"id":3,"options":{"legend":{"calcs":["lastNotNull","min","max","mean"],"displayMode":"table","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"single","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"disableTextWrap":false,"editorMode":"builder","expr":"redis_instantaneous_ops_per_sec{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"redis-instantaneos-ops-per-sec","range":true,"refId":"A","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_total_commands_processed{job=\"custom-exporter\"}","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis-total-commands-processed","range":true,"refId":"B","useBackend":false}],"title":"Throughput Overview","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"palette-classic-by-name"},"custom":{"axisBorderShow":false,"axisCenteredZero":false,"axisColorMode":"text","axisGridShow":true,"axisLabel":"","axisPlacement":"left","barAlignment":0,"barWidthFactor":0.6,"drawStyle":"line","fillOpacity":0,"gradientMode":"none","hideFrom":{"legend":false,"tooltip":false,"viz":false},"insertNulls":false,"lineInterpolation":"linear","lineStyle":{"fill":"solid"},"lineWidth":4,"pointSize":5,"scaleDistribution":{"type":"linear"},"showPoints":"always","spanNulls":false,"stacking":{"group":"A","mode":"none"},"thresholdsStyle":{"mode":"off"}},"fieldMinMax":false,"mappings":[],"min":0,"thresholds":{"mode":"absolute","steps":[{"color":"green","value":null},{"color":"red","value":80}]},"unit":"decmbytes"},"overrides":[]},"gridPos":{"h":9,"w":12,"x":12,"y":12},"id":2,"options":{"legend":{"calcs":["last","min","max","mean"],"displayMode":"table","placement":"bottom","showLegend":true},"tooltip":{"hideZeros":false,"mode":"none","sort":"none"}},"pluginVersion":"11.5.2","targets":[{"disableTextWrap":false,"editorMode":"code","expr":"redis_memory_usage_bytes / 1000000","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"redis-memory-usage-in-bytes","range":true,"refId":"A","useBackend":false},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"code","expr":"redis_rss_memory_usage_bytes / 1000000","fullMetaSearch":false,"hide":false,"includeNullMetadata":true,"instant":false,"legendFormat":"redis-rss-memory-usage-in-bytes","range":true,"refId":"B","useBackend":false}],"title":"Memory Usage Overview","type":"timeseries"},{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"fieldConfig":{"defaults":{"color":{"mode":"thresholds"},"decimals":1,"displayName":"Current Cache Hit Rate","fieldMinMax":false,"mappings":[],"max":1,"min":0,"thresholds":{"mode":"absolute","steps":[{"color":"transparent","value":null},{"color":"dark-red","value":0},{"color":"dark-red","value":0.5},{"color":"#EAB839","value":0.7},{"color":"green","value":0.9}]},"unit":"none"},"overrides":[]},"gridPos":{"h":8,"w":24,"x":0,"y":21},"id":1,"options":{"minVizHeight":1,"minVizWidth":75,"orientation":"horizontal","reduceOptions":{"calcs":["lastNotNull"],"fields":"","values":false},"showThresholdLabels":false,"showThresholdMarkers":true,"sizing":"auto","text":{}},"pluginVersion":"11.5.2","targets":[{"datasource":{"type":"prometheus","uid":"aedywwiz124g0a"},"disableTextWrap":false,"editorMode":"builder","expr":"redis_cache_hit_rate{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"legendFormat":"__auto","range":true,"refId":"A","useBackend":false}],"title":"Cache Hit Rate","type":"gauge"}],"preload":false,"refresh":"5s","schemaVersion":40,"tags":[],"templating":{"list":[]},"time":{"from":"now-5m","to":"now"},"timepicker":{},"timezone":"browser","title":"Redis High-Level KPI Dashboard","uid":"befr0y9wlsohsb","version":2,"weekStart":""}');
INSERT INTO dashboard_version VALUES(4,3,0,0,1,'2025-05-23 21:56:41',1,'','{"schemaVersion":17,"title":"Alerts","uid":"eemsi9qgyfpc0e","version":1}');
CREATE TABLE `team` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `org_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `uid` TEXT NULL, `email` TEXT NULL);
CREATE TABLE `team_member` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `team_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `external` INTEGER NULL, `permission` INTEGER NULL);
CREATE TABLE `dashboard_acl` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `dashboard_id` INTEGER NOT NULL
, `user_id` INTEGER NULL
, `team_id` INTEGER NULL
, `permission` INTEGER NOT NULL DEFAULT 4
, `role` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO dashboard_acl VALUES(1,-1,-1,NULL,NULL,1,'Viewer','2017-06-20','2017-06-20');
INSERT INTO dashboard_acl VALUES(2,-1,-1,NULL,NULL,2,'Editor','2017-06-20','2017-06-20');
CREATE TABLE `tag` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `key` TEXT NOT NULL
, `value` TEXT NOT NULL
);
CREATE TABLE `login_attempt` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `username` TEXT NOT NULL
, `ip_address` TEXT NOT NULL
, `created` INTEGER NOT NULL DEFAULT 0
);
INSERT INTO login_attempt VALUES(1,'admin','10.244.0.1',1748037228);
INSERT INTO login_attempt VALUES(2,'admin','10.244.0.1',1748037229);
CREATE TABLE `user_auth` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `user_id` INTEGER NOT NULL
, `auth_module` TEXT NOT NULL
, `auth_id` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `o_auth_access_token` TEXT NULL, `o_auth_refresh_token` TEXT NULL, `o_auth_token_type` TEXT NULL, `o_auth_expiry` DATETIME NULL, `o_auth_id_token` TEXT NULL);
CREATE TABLE `server_lock` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `operation_uid` TEXT NOT NULL
, `version` INTEGER NOT NULL
, `last_execution` INTEGER NOT NULL
);
INSERT INTO server_lock VALUES(1,'cleanup expired auth tokens',1,1748036595);
INSERT INTO server_lock VALUES(3,'delete old login attempts',2,1748037799);
CREATE TABLE `user_auth_token` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `user_id` INTEGER NOT NULL
, `auth_token` TEXT NOT NULL
, `prev_auth_token` TEXT NOT NULL
, `user_agent` TEXT NOT NULL
, `client_ip` TEXT NOT NULL
, `auth_token_seen` INTEGER NOT NULL
, `seen_at` INTEGER NULL
, `rotated_at` INTEGER NOT NULL
, `created_at` INTEGER NOT NULL
, `updated_at` INTEGER NOT NULL
, `revoked_at` INTEGER NULL, `external_session_id` INTEGER NULL);
INSERT INTO user_auth_token VALUES(1,1,'2a455acb282f8e45e2b6ac08e69b0414cab600fd7ed9d199597d7576e3f1f51c','2a455acb282f8e45e2b6ac08e69b0414cab600fd7ed9d199597d7576e3f1f51c','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','10.244.0.1',1,1748037233,1748037233,1748037233,1748037233,0,0);
CREATE TABLE `cache_data` (
`cache_key` TEXT PRIMARY KEY NOT NULL
, `data` BLOB NOT NULL
, `expires` INTEGER NOT NULL
, `created_at` INTEGER NOT NULL
);
INSERT INTO cache_data VALUES('id-token-1-user-1',X'65794a68624763694f694a46557a49314e694973496d74705a434936496d6c6b4c5449774d6a55744d4455745a584d794e5459694c434a30655841694f694a716433516966512e65794a68645751694f694a76636d63364d534973496d46316447686c626e5270593246305a57524365534936496e426863334e3362334a6b496977695a573168615777694f694a685a473170626b427362324e6862476876633351694c434a6c654841694f6a45334e4467774d7a63344d7a4d73496d6c68644349364d5463304f44417a4e7a497a4d7977696157526c626e52705a6d6c6c63694936496d4e6c62584e6f4d6e49324e5845774d3274694969776961584e7a496a6f696148523063446f764c327876593246736147397a64446f7a4d4441774c794973496d3568625755694f694a685a47317062694973496d35686257567a6347466a5a534936496d526c5a6d4631624851694c434a7a645749694f694a31633256794f6a45694c434a306558426c496a6f6964584e6c63694973496e567a5a584a755957316c496a6f69595752746157346966512e5f68687352756d614d35437568416e34777775635a33306c32745f716d4a54636667374b6b5a70462d394d6e544a703677366d704458766b544e4138474e31577972735365766a37426a5a327a364c49496668463851',569,1748037233);
INSERT INTO cache_data VALUES('id-token-0-user-1',X'65794a68624763694f694a46557a49314e694973496d74705a434936496d6c6b4c5449774d6a55744d4455745a584d794e5459694c434a30655841694f694a716433516966512e65794a68645751694f694a76636d63364d434973496d567459576c73496a6f6959575274615735416247396a5957786f62334e30496977695a586877496a6f784e7a51344d444d334f444d7a4c434a70595851694f6a45334e4467774d7a63794d7a4d73496d6c6b5a57353061575a705a5849694f694a6a5a57317a61444a794e6a56784d444e7259694973496d6c7a63794936496d6830644841364c79397362324e6862476876633351364d7a41774d4338694c434a755957316c496a6f6959575274615734694c434a755957316c63334268593255694f694a76636d63744d434973496e4e3159694936496e567a5a5849364d534973496e5235634755694f694a31633256794969776964584e6c636d3568625755694f694a685a47317062694a392e4f5a304671456b6e684b65336b63744a6a464d544a4d6f7565415a516845667079356e783379613151537974626c696a644370515f39537832662d6258677474596745556e464a706f48345736595a7a6e716f654977',569,1748037233);
CREATE TABLE `short_url` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `uid` TEXT NOT NULL
, `path` TEXT NOT NULL
, `created_by` INTEGER NOT NULL
, `created_at` INTEGER NOT NULL
, `last_seen_at` INTEGER NULL
);
CREATE TABLE `alert_instance` (
"rule_org_id" INTEGER NOT NULL
, "rule_uid" TEXT NOT NULL DEFAULT 0
, `labels` TEXT NOT NULL
, `labels_hash` TEXT NOT NULL
, `current_state` TEXT NOT NULL
, `current_state_since` INTEGER NOT NULL
, `last_eval_time` INTEGER NOT NULL
, `current_state_end` INTEGER NOT NULL DEFAULT 0, `current_reason` TEXT NULL, `result_fingerprint` TEXT NULL, `resolved_at` INTEGER NULL, `last_sent_at` INTEGER NULL, PRIMARY KEY ( "rule_org_id","rule_uid",`labels_hash` ));
INSERT INTO alert_instance VALUES(1,'aemsihdkfd69se','[["__alert_rule_namespace_uid__","eemsi9qgyfpc0e"],["__alert_rule_uid__","aemsihdkfd69se"],["__grafana_autogenerated__","true"],["__grafana_receiver__","personal"],["__name__","redis_cache_hit_rate"],["alertname","redis cache is under critical threshold"],["grafana_folder","Alerts"],["instance","custom-exporter-service.default:2112"],["job","custom-exporter"]]','4bb079a2b443ddef30fd13028a0071e201aced7c','Pending',1748037790,1748037790,1748038990,'','3b51d779dd840b88',NULL,NULL);
INSERT INTO alert_instance VALUES(1,'cemsierj0hbeoa','[["__alert_rule_namespace_uid__","eemsi9qgyfpc0e"],["__alert_rule_uid__","cemsierj0hbeoa"],["__grafana_autogenerated__","true"],["__grafana_receiver__","personal"],["__name__","pod_status"],["alertname","Redis Master Pod Down"],["grafana_folder","Alerts"],["instance","custom-exporter-service.default:2112"],["job","custom-exporter"],["namespace","default"],["pod","redis-master-0"]]','3c38856eca5945402ee34631c3c3ac74252671d9','Normal',1748037790,1748037790,1748037790,'','519809891d9b56c7',NULL,NULL);
INSERT INTO alert_instance VALUES(1,'cemsij8y5reo0a','[["__alert_rule_namespace_uid__","eemsi9qgyfpc0e"],["__alert_rule_uid__","cemsij8y5reo0a"],["__grafana_autogenerated__","true"],["__grafana_receiver__","personal"],["__name__","redis_connected_slaves"],["alertname","connectedSlaves is below 0"],["grafana_folder","Alerts"],["instance","custom-exporter-service.default:2112"],["job","custom-exporter"]]','41217b52835ee14326c8e37b3b775306ca8397db','Normal',1748037790,1748037790,1748037790,'','608bbc819f36687b',NULL,NULL);
INSERT INTO alert_instance VALUES(1,'eemsil803s5xcd','[["__alert_rule_namespace_uid__","eemsi9qgyfpc0e"],["__alert_rule_uid__","eemsil803s5xcd"],["__grafana_autogenerated__","true"],["__grafana_receiver__","personal"],["alertname","Redis memory usage is close to the max"],["grafana_folder","Alerts"],["instance","custom-exporter-service.default:2112"],["job","custom-exporter"]]','6c1bed2b2e26d11ca39240d88d2a05cccf960f45','Normal',1748037790,1748037790,1748037790,'','f3a27e057f687a20',NULL,NULL);
CREATE TABLE `alert_rule` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `title` TEXT NOT NULL
, `condition` TEXT NOT NULL
, `data` TEXT NOT NULL
, `updated` DATETIME NOT NULL
, `interval_seconds` INTEGER NOT NULL DEFAULT 60
, `version` INTEGER NOT NULL DEFAULT 0
, `uid` TEXT NOT NULL DEFAULT 0
, `namespace_uid` TEXT NOT NULL
, `rule_group` TEXT NOT NULL
, `no_data_state` TEXT NOT NULL DEFAULT 'NoData'
, `exec_err_state` TEXT NOT NULL DEFAULT 'Alerting'
, `for` INTEGER NOT NULL DEFAULT 0, `annotations` TEXT NULL, `labels` TEXT NULL, `dashboard_uid` TEXT NULL, `panel_id` INTEGER NULL, `rule_group_idx` INTEGER NOT NULL DEFAULT 1, `is_paused` INTEGER NOT NULL DEFAULT 0, `notification_settings` TEXT NULL, `record` TEXT NULL, `metadata` TEXT NULL);
INSERT INTO alert_rule VALUES(1,1,'Redis Master Pod Down','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"pod_status{pod=\"redis-master-0\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]','2025-05-23 22:00:16',300,4,'cemsierj0hbeoa','eemsi9qgyfpc0e','5m','NoData','Error',600000000000,'{"summary":"ALERT: Redis Master Pod Down\n\n                                The Redis master pod in the ''default'' namespace is currently not running.\n\n                                Pod: redis-master*\n                                Duration: At least 1 minute\n                                Suggestion: Check the pod status with kubectl get pods and logs with kubectl logs.\n\n                                Severity: Critical"}','',NULL,NULL,1,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule VALUES(2,1,'redis cache is under critical threshold','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"redis_cache_hit_rate{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[0.6],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]','2025-05-23 22:00:16',300,3,'aemsihdkfd69se','eemsi9qgyfpc0e','5m','NoData','Error',600000000000,'{"summary":"ALERT: Redis Cache Usage Critical\n\n                                Redis cache usage has exceeded the critical threshold.\n\n                                Metric: Cache usage\n                                Threshold: Above defined critical limit\n                                Duration: At least 1 minute\n                                Suggestion: Review Redis memory configuration, check for large keys or memory leaks, and consider evicting data or scaling the instance.\n\n                                Severity: Critical"}','',NULL,NULL,2,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule VALUES(3,1,'connectedSlaves is below 0','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"redis_connected_slaves{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]','2025-05-23 22:00:16',300,2,'cemsij8y5reo0a','eemsi9qgyfpc0e','5m','NoData','Error',600000000000,'{"summary":"ALERT: No Redis Slave Replicas Detected\n\n                                Redis master has no connected slave replicas, which may impact high availability and data redundancy.\n\n                                Metric: Connected slave replicas\n                                Threshold: 0 replicas\n                                Duration: At least 1 minute\n                                Suggestion: Verify replica configuration, check network connectivity, review Redis logs for replication issues, and restart or redeploy replica nodes if needed.\n\n                                Severity: Critical"}','',NULL,NULL,3,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule VALUES(4,1,'Redis memory usage is close to the max','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"editorMode":"code","expr":"redis_rss_memory_usage_bytes{job=\"custom-exporter\"} - redis_memory_usage_bytes{job=\"custom-exporter\"}","instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A"}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[600],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]','2025-05-23 22:00:16',300,1,'eemsil803s5xcd','eemsi9qgyfpc0e','5m','NoData','Error',600000000000,'{"summary":"ALERT: Redis Memory Usage Near Maximum Capacity\n\n                                Redis memory usage is approaching the maximum configured limit, which may lead to evictions, errors, or degraded performance.\n\n                                Metric: Memory usage\n                                Suggestion: Review Redis memory configuration, monitor key growth, check for large or unnecessary keys, and consider increasing maxmemory or enabling appropriate eviction policies.\n\n                                Severity: Critica"}','',NULL,NULL,4,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
CREATE TABLE `alert_rule_version` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `rule_org_id` INTEGER NOT NULL
, `rule_uid` TEXT NOT NULL DEFAULT 0
, `rule_namespace_uid` TEXT NOT NULL
, `rule_group` TEXT NOT NULL
, `parent_version` INTEGER NOT NULL
, `restored_from` INTEGER NOT NULL
, `version` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `title` TEXT NOT NULL
, `condition` TEXT NOT NULL
, `data` TEXT NOT NULL
, `interval_seconds` INTEGER NOT NULL
, `no_data_state` TEXT NOT NULL DEFAULT 'NoData'
, `exec_err_state` TEXT NOT NULL DEFAULT 'Alerting'
, `for` INTEGER NOT NULL DEFAULT 0, `annotations` TEXT NULL, `labels` TEXT NULL, `rule_group_idx` INTEGER NOT NULL DEFAULT 1, `is_paused` INTEGER NOT NULL DEFAULT 0, `notification_settings` TEXT NULL, `record` TEXT NULL, `metadata` TEXT NULL);
INSERT INTO alert_rule_version VALUES(1,1,'cemsierj0hbeoa','eemsi9qgyfpc0e','5m',0,0,1,'2025-05-23 21:58:15','Redis Master Pod Down','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"pod_status{pod=\"redis-master-0\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Master Pod Down\n\n                                The Redis master pod in the ''default'' namespace is currently not running.\n\n                                Pod: redis-master*\n                                Duration: At least 1 minute\n                                Suggestion: Check the pod status with kubectl get pods and logs with kubectl logs.\n\n                                Severity: Critical"}','',1,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(2,1,'cemsierj0hbeoa','eemsi9qgyfpc0e','5m',1,0,2,'2025-05-23 21:59:04','Redis Master Pod Down','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"pod_status{pod=\"redis-master-0\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Master Pod Down\n\n                                The Redis master pod in the ''default'' namespace is currently not running.\n\n                                Pod: redis-master*\n                                Duration: At least 1 minute\n                                Suggestion: Check the pod status with kubectl get pods and logs with kubectl logs.\n\n                                Severity: Critical"}','',1,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(3,1,'aemsihdkfd69se','eemsi9qgyfpc0e','5m',0,0,1,'2025-05-23 21:59:04','redis cache is under critical threshold','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"redis_cache_hit_rate{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[0.6],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Cache Usage Critical\n\n                                Redis cache usage has exceeded the critical threshold.\n\n                                Metric: Cache usage\n                                Threshold: Above defined critical limit\n                                Duration: At least 1 minute\n                                Suggestion: Review Redis memory configuration, check for large keys or memory leaks, and consider evicting data or scaling the instance.\n\n                                Severity: Critical"}','',2,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(4,1,'cemsierj0hbeoa','eemsi9qgyfpc0e','5m',2,0,3,'2025-05-23 21:59:39','Redis Master Pod Down','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"pod_status{pod=\"redis-master-0\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Master Pod Down\n\n                                The Redis master pod in the ''default'' namespace is currently not running.\n\n                                Pod: redis-master*\n                                Duration: At least 1 minute\n                                Suggestion: Check the pod status with kubectl get pods and logs with kubectl logs.\n\n                                Severity: Critical"}','',1,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(5,1,'aemsihdkfd69se','eemsi9qgyfpc0e','5m',1,0,2,'2025-05-23 21:59:39','redis cache is under critical threshold','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"redis_cache_hit_rate{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[0.6],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Cache Usage Critical\n\n                                Redis cache usage has exceeded the critical threshold.\n\n                                Metric: Cache usage\n                                Threshold: Above defined critical limit\n                                Duration: At least 1 minute\n                                Suggestion: Review Redis memory configuration, check for large keys or memory leaks, and consider evicting data or scaling the instance.\n\n                                Severity: Critical"}','',2,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(6,1,'cemsij8y5reo0a','eemsi9qgyfpc0e','5m',0,0,1,'2025-05-23 21:59:39','connectedSlaves is below 0','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"redis_connected_slaves{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: No Redis Slave Replicas Detected\n\n                                Redis master has no connected slave replicas, which may impact high availability and data redundancy.\n\n                                Metric: Connected slave replicas\n                                Threshold: 0 replicas\n                                Duration: At least 1 minute\n                                Suggestion: Verify replica configuration, check network connectivity, review Redis logs for replication issues, and restart or redeploy replica nodes if needed.\n\n                                Severity: Critical"}','',3,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(7,1,'cemsierj0hbeoa','eemsi9qgyfpc0e','5m',3,0,4,'2025-05-23 22:00:16','Redis Master Pod Down','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"pod_status{pod=\"redis-master-0\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Master Pod Down\n\n                                The Redis master pod in the ''default'' namespace is currently not running.\n\n                                Pod: redis-master*\n                                Duration: At least 1 minute\n                                Suggestion: Check the pod status with kubectl get pods and logs with kubectl logs.\n\n                                Severity: Critical"}','',1,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(8,1,'aemsihdkfd69se','eemsi9qgyfpc0e','5m',2,0,3,'2025-05-23 22:00:16','redis cache is under critical threshold','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"redis_cache_hit_rate{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[0.6],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Cache Usage Critical\n\n                                Redis cache usage has exceeded the critical threshold.\n\n                                Metric: Cache usage\n                                Threshold: Above defined critical limit\n                                Duration: At least 1 minute\n                                Suggestion: Review Redis memory configuration, check for large keys or memory leaks, and consider evicting data or scaling the instance.\n\n                                Severity: Critical"}','',2,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(9,1,'cemsij8y5reo0a','eemsi9qgyfpc0e','5m',1,0,2,'2025-05-23 22:00:16','connectedSlaves is below 0','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"disableTextWrap":false,"editorMode":"builder","expr":"redis_connected_slaves{job=\"custom-exporter\"}","fullMetaSearch":false,"includeNullMetadata":true,"instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A","useBackend":false}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[1],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: No Redis Slave Replicas Detected\n\n                                Redis master has no connected slave replicas, which may impact high availability and data redundancy.\n\n                                Metric: Connected slave replicas\n                                Threshold: 0 replicas\n                                Duration: At least 1 minute\n                                Suggestion: Verify replica configuration, check network connectivity, review Redis logs for replication issues, and restart or redeploy replica nodes if needed.\n\n                                Severity: Critical"}','',3,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
INSERT INTO alert_rule_version VALUES(10,1,'eemsil803s5xcd','eemsi9qgyfpc0e','5m',0,0,1,'2025-05-23 22:00:16','Redis memory usage is close to the max','C','[{"refId":"A","queryType":"","relativeTimeRange":{"from":600,"to":0},"datasourceUid":"aemsi69pwzsowe","model":{"editorMode":"code","expr":"redis_rss_memory_usage_bytes{job=\"custom-exporter\"} - redis_memory_usage_bytes{job=\"custom-exporter\"}","instant":true,"intervalMs":1000,"legendFormat":"__auto","maxDataPoints":43200,"range":false,"refId":"A"}},{"refId":"C","queryType":"","relativeTimeRange":{"from":0,"to":0},"datasourceUid":"__expr__","model":{"conditions":[{"evaluator":{"params":[600],"type":"lt"},"operator":{"type":"and"},"query":{"params":["C"]},"reducer":{"params":[],"type":"last"},"type":"query"}],"datasource":{"type":"__expr__","uid":"__expr__"},"expression":"A","intervalMs":1000,"maxDataPoints":43200,"refId":"C","type":"threshold"}}]',300,'NoData','Error',600000000000,'{"summary":"ALERT: Redis Memory Usage Near Maximum Capacity\n\n                                Redis memory usage is approaching the maximum configured limit, which may lead to evictions, errors, or degraded performance.\n\n                                Metric: Memory usage\n                                Suggestion: Review Redis memory configuration, monitor key growth, check for large or unnecessary keys, and consider increasing maxmemory or enabling appropriate eviction policies.\n\n                                Severity: Critica"}','',4,0,'[{"receiver":"personal"}]','','{"editor_settings":{"simplified_query_and_expressions_section":false,"simplified_notifications_section":false}}');
CREATE TABLE `alert_configuration` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `alertmanager_configuration` TEXT NOT NULL
, `configuration_version` TEXT NOT NULL
, `created_at` INTEGER NOT NULL
, `default` INTEGER NOT NULL DEFAULT 0, `org_id` INTEGER NOT NULL DEFAULT 0, `configuration_hash` TEXT NOT NULL DEFAULT 'not-yet-calculated');
INSERT INTO alert_configuration VALUES(1,'{"template_files":null,"alertmanager_config":{"route":{"receiver":"grafana-default-email","group_by":["grafana_folder","alertname"]},"receivers":[{"name":"grafana-default-email","grafana_managed_receiver_configs":[{"uid":"","name":"email receiver","type":"email","disableResolveMessage":false,"settings":{"addresses":"\u003cexample@email.com\u003e"}}]},{"name":"personal","grafana_managed_receiver_configs":[{"uid":"bemsid6ff1fk0e","name":"personal","type":"email","disableResolveMessage":false,"settings":{"addresses":"sooky.adam@gmail.com","singleEmail":false}}]}]}}','v1',1748036595,1,1,'60b1f8687bdd2f17ef6ec4fce5c8e30a');
CREATE TABLE `ngalert_configuration` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `alertmanagers` TEXT NULL
, `created_at` INTEGER NOT NULL
, `updated_at` INTEGER NOT NULL
, `send_alerts_to` INTEGER NOT NULL DEFAULT 0);
CREATE TABLE `provenance_type` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `record_key` TEXT NOT NULL
, `record_type` TEXT NOT NULL
, `provenance` TEXT NOT NULL
);
INSERT INTO provenance_type VALUES(1,1,'bemsid6ff1fk0e','contactPoint','');
CREATE TABLE `alert_image` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `token` TEXT NOT NULL
, `path` TEXT NOT NULL
, `url` TEXT NOT NULL
, `created_at` DATETIME NOT NULL
, `expires_at` DATETIME NOT NULL
);
CREATE TABLE `alert_configuration_history` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL DEFAULT 0
, `alertmanager_configuration` TEXT NOT NULL
, `configuration_hash` TEXT NOT NULL DEFAULT 'not-yet-calculated'
, `configuration_version` TEXT NOT NULL
, `created_at` INTEGER NOT NULL
, `default` INTEGER NOT NULL DEFAULT 0
, `last_applied` INTEGER NOT NULL DEFAULT 0);
INSERT INTO alert_configuration_history VALUES(1,1,replace('{\n	"alertmanager_config": {\n		"route": {\n			"receiver": "grafana-default-email",\n			"group_by": ["grafana_folder", "alertname"]\n		},\n		"receivers": [{\n			"name": "grafana-default-email",\n			"grafana_managed_receiver_configs": [{\n				"uid": "",\n				"name": "email receiver",\n				"type": "email",\n				"settings": {\n					"addresses": "<example@email.com>"\n				}\n			}]\n		}]\n	}\n}\n','\n',char(10)),'ed091fbc8c639dd8063190127c806946','v1',1748036595,1,1748036595);
INSERT INTO alert_configuration_history VALUES(2,1,'{"template_files":null,"alertmanager_config":{"route":{"receiver":"grafana-default-email","group_by":["grafana_folder","alertname"]},"receivers":[{"name":"grafana-default-email","grafana_managed_receiver_configs":[{"uid":"","name":"email receiver","type":"email","disableResolveMessage":false,"settings":{"addresses":"\u003cexample@email.com\u003e"}}]},{"name":"personal","grafana_managed_receiver_configs":[{"uid":"bemsid6ff1fk0e","name":"personal","type":"email","disableResolveMessage":false,"settings":{"addresses":"sooky.adam@gmail.com","singleEmail":false}}]}]}}','60b1f8687bdd2f17ef6ec4fce5c8e30a','v1',1748037465,0,1748037495);
CREATE TABLE `library_element` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `folder_id` INTEGER NOT NULL
, `uid` TEXT NOT NULL
, `name` TEXT NOT NULL
, `kind` INTEGER NOT NULL
, `type` TEXT NOT NULL
, `description` TEXT NOT NULL
, `model` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `created_by` INTEGER NOT NULL
, `updated` DATETIME NOT NULL
, `updated_by` INTEGER NOT NULL
, `version` INTEGER NOT NULL
, `folder_uid` TEXT NULL);
CREATE TABLE `library_element_connection` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `element_id` INTEGER NOT NULL
, `kind` INTEGER NOT NULL
, `connection_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `created_by` INTEGER NOT NULL
);
CREATE TABLE `data_keys` (
"name" TEXT PRIMARY KEY NOT NULL
, `active` INTEGER NOT NULL
, `scope` TEXT NOT NULL
, `provider` TEXT NOT NULL
, `encrypted_data` BLOB NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, "label" TEXT NOT NULL DEFAULT '');
INSERT INTO data_keys VALUES('femsi0st45edce',1,'root','secretKey.v1',X'2a5957567a4c574e6d59672a456f6d75557361524b619ebeca7a5b5a0c24e67bc530d9bbd28e5b2a2bf00cb6339cb0cb08f7102d','2025-05-23 21:53:53','2025-05-23 21:53:53','2025-05-23/root@secretKey.v1');
CREATE TABLE `secrets` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `namespace` TEXT NOT NULL
, `type` TEXT NOT NULL
, `value` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO secrets VALUES(1,1,'prometheus','datasource','I1ptVnRjMmt3YzNRME5XVmtZMlUjKllXVnpMV05tWWcqdjVvY0ZTekTPWz/tsyW5hgDQzHSWMNOq6nk','2025-05-23 21:55:36','2025-05-23 21:55:44');
CREATE TABLE `kv_store` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `namespace` TEXT NOT NULL
, `key` TEXT NOT NULL
, `value` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO kv_store VALUES(1,0,'ngalert.migration','currentAlertingType','Legacy','2025-05-23 21:43:14','2025-05-23 21:43:14');
INSERT INTO kv_store VALUES(2,0,'datasource','secretMigrationStatus','compatible','2025-05-23 21:43:15','2025-05-23 21:43:15');
INSERT INTO kv_store VALUES(3,0,'plugin.angularpatterns','angular_patterns','[{"Name":"PanelCtrl","Pattern":"PanelCtrl","Type":"contains"},{"Name":"ConfigCtrl","Pattern":"ConfigCtrl","Type":"contains"},{"Name":"app/plugins/sdk","Pattern":"app/plugins/sdk","Type":"contains"},{"Name":"Angular Specific Function","Pattern":"angular.isNumber(","Type":"contains"},{"Name":"ctrl.annotation","Pattern":"ctrl.annotation","Type":"contains"},{"Name":"QueryCtrl","Pattern":"[\"'']QueryCtrl[\"'']","Type":"regex"}]','2025-05-23 21:43:15','2025-05-23 21:43:15');
INSERT INTO kv_store VALUES(4,0,'plugin.angularpatterns','last_updated','2025-05-23T21:43:15Z','2025-05-23 21:43:15','2025-05-23 21:43:15');
INSERT INTO kv_store VALUES(5,0,'plugin.angularpatterns','etag','"1a8-1yOry0c74BKAzc7BUbZdNV0sYic"','2025-05-23 21:43:15','2025-05-23 21:43:15');
INSERT INTO kv_store VALUES(6,0,'plugin.publickeys','key-7e4d0c6a708866e7',replace(replace('-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: OpenPGP.js v4.10.1\r\nComment: https://openpgpjs.org\r\n\r\nxpMEXpTXXxMFK4EEACMEIwQBiOUQhvGbDLvndE0fEXaR0908wXzPGFpf0P0Z\r\nHJ06tsq+0higIYHp7WTNJVEZtcwoYLcPRGaa9OQqbUU63BEyZdgAkPTz3RFd\r\n5+TkDWZizDcaVFhzbDd500yTwexrpIrdInwC/jrgs7Zy/15h8KA59XXUkdmT\r\nYB6TR+OA9RKME+dCJozNGUdyYWZhbmEgPGVuZ0BncmFmYW5hLmNvbT7CvAQQ\r\nEwoAIAUCXpTXXwYLCQcIAwIEFQgKAgQWAgEAAhkBAhsDAh4BAAoJEH5NDGpw\r\niGbnaWoCCQGQ3SQnCkRWrG6XrMkXOKfDTX2ow9fuoErN46BeKmLM4f1EkDZQ\r\nTpq3SE8+My8B5BIH3SOcBeKzi3S57JHGBdFA+wIJAYWMrJNIvw8GeXne+oUo\r\nNzzACdvfqXAZEp/HFMQhCKfEoWGJE8d2YmwY2+3GufVRTI5lQnZOHLE8L/Vc\r\n1S5MXESjzpcEXpTXXxIFK4EEACMEIwQBtHX/SD5Qm3v4V92qpaIZQgtTX0sT\r\ncFPjYWAHqsQ1iENrYN/vg1wU3ADlYATvydOQYvkTyT/tbDvx2Fse8PL84MQA\r\nYKKQ6AJ3gLVvmeouZdU03YoV4MYaT8KbnJUkZQZkqdz2riOlySNI9CG3oYmv\r\nomjUAtzgAgnCcurfGLZkkMxlmY8DAQoJwqQEGBMKAAkFAl6U118CGwwACgkQ\r\nfk0ManCIZuc0jAIJAVw2xdLr4ZQqPUhubrUyFcqlWoW8dQoQagwO8s8ubmby\r\nKuLA9FWJkfuuRQr+O9gHkDVCez3aism7zmJBqIOi38aNAgjJ3bo6leSS2jR/\r\nx5NqiKVi83tiXDPncDQYPymOnMhW0l7CVA7wj75HrFvvlRI/4MArlbsZ2tBn\r\nN1c5v9v/4h6qeA==\r\n=DNbR\r\n-----END PGP PUBLIC KEY BLOCK-----\r\n','\r',char(13)),'\n',char(10)),'2025-05-23 21:43:15','2025-05-23 21:43:15');
INSERT INTO kv_store VALUES(7,0,'plugin.publickeys','last_updated','2025-05-23T21:43:15Z','2025-05-23 21:43:15','2025-05-23 21:43:15');
INSERT INTO kv_store VALUES(8,1,'alertmanager','notifications','','2025-05-23 21:58:18','2025-05-23 21:58:18');
INSERT INTO kv_store VALUES(9,1,'alertmanager','silences','','2025-05-23 21:58:18','2025-05-23 21:58:18');
CREATE TABLE `permission` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `role_id` INTEGER NOT NULL
, `action` TEXT NOT NULL
, `scope` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `kind` TEXT NOT NULL DEFAULT '', `attribute` TEXT NOT NULL DEFAULT '', `identifier` TEXT NOT NULL DEFAULT '');
INSERT INTO permission VALUES(1,1,'dashboards:admin','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(2,1,'dashboards:read','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(3,1,'dashboards.permissions:read','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(4,1,'annotations:write','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(5,1,'annotations:read','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(6,1,'annotations:delete','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(7,1,'annotations:create','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(8,1,'dashboards:write','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(9,1,'dashboards:delete','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(10,1,'dashboards.permissions:write','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(11,2,'dashboards:edit','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(12,2,'dashboards:write','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(13,2,'dashboards:delete','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(14,2,'annotations:read','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(15,2,'annotations:write','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(16,2,'annotations:delete','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(17,2,'annotations:create','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(18,2,'dashboards:read','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(19,3,'dashboards:view','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(20,3,'dashboards:read','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(21,3,'annotations:read','dashboards:uid:befr0y9wlsohsb','2025-05-23 21:55:19','2025-05-23 21:55:19','dashboards','uid','befr0y9wlsohsb');
INSERT INTO permission VALUES(22,1,'dashboards:admin','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(23,1,'dashboards:read','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(24,1,'annotations:write','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(25,1,'annotations:delete','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(26,1,'annotations:create','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(27,1,'dashboards:write','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(28,1,'dashboards:delete','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(29,1,'dashboards.permissions:read','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(30,1,'dashboards.permissions:write','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(31,1,'annotations:read','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(32,2,'dashboards:edit','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(33,2,'annotations:create','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(34,2,'dashboards:read','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(35,2,'dashboards:write','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(36,2,'dashboards:delete','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(37,2,'annotations:read','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(38,2,'annotations:write','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(39,2,'annotations:delete','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(40,3,'dashboards:view','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(41,3,'dashboards:read','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(42,3,'annotations:read','dashboards:uid:cegcdx7ggs6ioe','2025-05-23 21:55:25','2025-05-23 21:55:25','dashboards','uid','cegcdx7ggs6ioe');
INSERT INTO permission VALUES(43,3,'datasources:read','datasources:uid:aemsi69pwzsowe','2025-05-23 21:55:36','2025-05-23 21:55:36','datasources','uid','aemsi69pwzsowe');
INSERT INTO permission VALUES(44,3,'datasources:query','datasources:uid:aemsi69pwzsowe','2025-05-23 21:55:36','2025-05-23 21:55:36','datasources','uid','aemsi69pwzsowe');
INSERT INTO permission VALUES(45,2,'datasources:read','datasources:uid:aemsi69pwzsowe','2025-05-23 21:55:36','2025-05-23 21:55:36','datasources','uid','aemsi69pwzsowe');
INSERT INTO permission VALUES(46,2,'datasources:query','datasources:uid:aemsi69pwzsowe','2025-05-23 21:55:36','2025-05-23 21:55:36','datasources','uid','aemsi69pwzsowe');
INSERT INTO permission VALUES(47,1,'folders:admin','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(48,1,'dashboards:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(49,1,'annotations:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(50,1,'alert.silences:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(51,1,'dashboards:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(52,1,'alert.rules:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(53,1,'alert.silences:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(54,1,'folders.permissions:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(55,1,'dashboards:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(56,1,'alert.rules:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(57,1,'alert.rules:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(58,1,'alert.rules:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(59,1,'annotations:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(60,1,'annotations:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(61,1,'annotations:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(62,1,'folders:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(63,1,'library.panels:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(64,1,'folders.permissions:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(65,1,'dashboards:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(66,1,'dashboards.permissions:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(67,1,'folders:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(68,1,'library.panels:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(69,1,'folders:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(70,1,'alert.silences:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(71,1,'library.panels:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(72,1,'library.panels:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(73,1,'dashboards.permissions:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(74,2,'folders:edit','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(75,2,'alert.rules:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(76,2,'library.panels:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(77,2,'dashboards:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(78,2,'dashboards:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(79,2,'annotations:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(80,2,'folders:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(81,2,'alert.rules:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(82,2,'annotations:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(83,2,'alert.silences:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(84,2,'folders:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(85,2,'alert.rules:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(86,2,'alert.silences:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(87,2,'annotations:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(88,2,'folders:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(89,2,'library.panels:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(90,2,'alert.silences:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(91,2,'library.panels:delete','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(92,2,'dashboards:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(93,2,'annotations:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(94,2,'alert.rules:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(95,2,'dashboards:create','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(96,2,'library.panels:write','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(97,3,'folders:view','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(98,3,'dashboards:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(99,3,'annotations:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(100,3,'folders:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(101,3,'alert.rules:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(102,3,'library.panels:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(103,3,'alert.silences:read','folders:uid:eemsi9qgyfpc0e','2025-05-23 21:56:41','2025-05-23 21:56:41','folders','uid','eemsi9qgyfpc0e');
INSERT INTO permission VALUES(104,2,'alert.notifications.receivers:read','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(105,2,'alert.notifications.receivers:write','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(106,2,'alert.notifications.receivers:delete','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(107,3,'alert.notifications.receivers:read','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(108,1,'receivers.permissions:read','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(109,1,'receivers.permissions:write','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(110,1,'alert.notifications.receivers:read','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(111,1,'alert.notifications.receivers:write','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(112,1,'alert.notifications.receivers:delete','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
INSERT INTO permission VALUES(113,1,'alert.notifications.receivers.secrets:read','receivers:uid:cGVyc29uYWw','2025-05-23 21:57:45','2025-05-23 21:57:45','receivers','uid','cGVyc29uYWw');
CREATE TABLE `role` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `description` TEXT NULL
, `version` INTEGER NOT NULL
, `org_id` INTEGER NOT NULL
, `uid` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `display_name` TEXT NULL, `group_name` TEXT NULL, `hidden` INTEGER NOT NULL DEFAULT 0);
INSERT INTO role VALUES(1,'managed:users:1:permissions','',0,1,'femsi5dvpl4owf','2025-05-23 21:55:19','2025-05-23 21:55:19','','',0);
INSERT INTO role VALUES(2,'managed:builtins:editor:permissions','',0,1,'demsi5dvzkq2oe','2025-05-23 21:55:19','2025-05-23 21:55:19','','',0);
INSERT INTO role VALUES(3,'managed:builtins:viewer:permissions','',0,1,'aemsi5dw4kirkd','2025-05-23 21:55:19','2025-05-23 21:55:19','','',0);
CREATE TABLE `team_role` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `team_id` INTEGER NOT NULL
, `role_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
);
CREATE TABLE `user_role` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `org_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `role_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `group_mapping_uid` TEXT NULL DEFAULT '');
INSERT INTO user_role VALUES(1,1,1,1,'2025-05-23 21:55:19','');
CREATE TABLE `builtin_role` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `role` TEXT NOT NULL
, `role_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `org_id` INTEGER NOT NULL DEFAULT 0);
INSERT INTO builtin_role VALUES(1,'Editor',2,'2025-05-23 21:55:19','2025-05-23 21:55:19',1);
INSERT INTO builtin_role VALUES(2,'Viewer',3,'2025-05-23 21:55:19','2025-05-23 21:55:19',1);
CREATE TABLE `query_history` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `uid` TEXT NOT NULL
, `org_id` INTEGER NOT NULL
, `datasource_uid` TEXT NOT NULL
, `created_by` INTEGER NOT NULL
, `created_at` INTEGER NOT NULL
, `comment` TEXT NOT NULL
, `queries` TEXT NOT NULL
);
CREATE TABLE `query_history_details` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `query_history_item_uid` TEXT NOT NULL
, `datasource_uid` TEXT NOT NULL
);
CREATE TABLE `query_history_star` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `query_uid` TEXT NOT NULL
, `user_id` INTEGER NOT NULL
, `org_id` INTEGER NOT NULL DEFAULT 1);
CREATE TABLE `correlation` (
`uid` TEXT NOT NULL
, `org_id` INTEGER NOT NULL DEFAULT 0
, `source_uid` TEXT NOT NULL
, `target_uid` TEXT NULL
, `label` TEXT NOT NULL
, `description` TEXT NOT NULL
, `config` TEXT NULL
, `provisioned` INTEGER NOT NULL DEFAULT 0, `type` TEXT NOT NULL DEFAULT 'query', PRIMARY KEY ( `uid`,`org_id`,`source_uid` ));
CREATE TABLE `entity_event` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `entity_id` TEXT NOT NULL
, `event_type` TEXT NOT NULL
, `created` INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS "dashboard_public" (
`uid` TEXT PRIMARY KEY NOT NULL
, `dashboard_uid` TEXT NOT NULL
, `org_id` INTEGER NOT NULL
, `time_settings` TEXT NULL
, `template_variables` TEXT NULL
, `access_token` TEXT NOT NULL
, `created_by` INTEGER NOT NULL
, `updated_by` INTEGER NULL
, `created_at` DATETIME NOT NULL
, `updated_at` DATETIME NULL
, `is_enabled` INTEGER NOT NULL DEFAULT 0
, `annotations_enabled` INTEGER NOT NULL DEFAULT 0, `time_selection_enabled` INTEGER NOT NULL DEFAULT 0, `share` TEXT NOT NULL DEFAULT 'public');
CREATE TABLE `file` (
`path` TEXT NOT NULL
, `path_hash` TEXT NOT NULL
, `parent_folder_path_hash` TEXT NOT NULL
, `contents` BLOB NOT NULL
, `etag` TEXT NOT NULL
, `cache_control` TEXT NOT NULL
, `content_disposition` TEXT NOT NULL
, `updated` DATETIME NOT NULL
, `created` DATETIME NOT NULL
, `size` INTEGER NOT NULL
, `mime_type` TEXT NOT NULL
);
CREATE TABLE `file_meta` (
`path_hash` TEXT NOT NULL
, `key` TEXT NOT NULL
, `value` TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS "seed_assignment" (
		    id INTEGER PRIMARY KEY AUTOINCREMENT,
			builtin_role TEXT,
			action TEXT,
			scope TEXT,
			role_name TEXT
		, `origin` TEXT NULL);
CREATE TABLE `folder` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `uid` TEXT NOT NULL
, `org_id` INTEGER NOT NULL
, `title` TEXT NOT NULL
, `description` TEXT NULL
, `parent_uid` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO folder VALUES(1,'eemsi9qgyfpc0e',1,'Alerts','',NULL,'2025-05-23 21:56:41.008248184+00:00','2025-05-23 21:56:41.008248253+00:00');
CREATE TABLE `anon_device` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `client_ip` TEXT NOT NULL
, `created_at` DATETIME NOT NULL
, `device_id` TEXT NOT NULL
, `updated_at` DATETIME NOT NULL
, `user_agent` TEXT NOT NULL
);
CREATE TABLE `signing_key` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `key_id` TEXT NOT NULL
, `private_key` TEXT NOT NULL
, `added_at` DATETIME NOT NULL
, `expires_at` DATETIME NULL
, `alg` TEXT NOT NULL
);
INSERT INTO signing_key VALUES(1,'id-2025-05-es256',X'49317074566e526a4d6d7433597a4e524d453558566d745a4d6c556a4b6c6c58566e704d56303574575763715a7a4e72555646445545733359487537642f2f3374586372526f537a31554c5030424c66366862314170644c686c4d367642394f7a4d5a516c33787277793743417672765454726f6635556b6475692b325363674461706b306a414e4b6976686645444b717a78512f7834617149743637666c4f5469507a2b55354a735a75424e5047563061427745705572582b34442b767272517670676a534d6b503769465741766a306b784933767231457946756d73675541664671625958555651734430635a315078517146594a694a63466a6b57616c505265516c5456774a597844446a73524f772f4a36797433383954574e6750304c4c637558524c784a52485a61484c434c74495063554d4c64376e586d6f7a3443626a4f63634e36416e7757307775746239664a4d456b507975703875384b54384834573347544e33526a754a54497264564364547662416d54706b786b706c78354c346436517038744e755251','2025-05-23 21:53:53.496036391+00:00','2025-06-22 21:53:53.496036391+00:00','ES256');
CREATE TABLE `sso_setting` (
`id` TEXT PRIMARY KEY NOT NULL
, `provider` TEXT NOT NULL
, `settings` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `is_deleted` INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE `cloud_migration_session` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `uid` TEXT NULL
, `auth_token` TEXT NULL
, `slug` TEXT NOT NULL
, `stack_id` INTEGER NOT NULL
, `region_slug` TEXT NOT NULL
, `cluster_slug` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `org_id` INTEGER NOT NULL DEFAULT 1);
CREATE TABLE `cloud_migration_snapshot` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `uid` TEXT NULL
, `session_uid` TEXT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `finished` DATETIME NULL
, `upload_url` TEXT NULL, `status` TEXT NOT NULL, `local_directory` TEXT NULL, `gms_snapshot_uid` TEXT NULL, `encryption_key` TEXT NULL, `error_string` TEXT NULL);
CREATE TABLE `cloud_migration_resource` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `uid` TEXT NOT NULL
, `resource_type` TEXT NOT NULL
, `resource_uid` TEXT NOT NULL
, `status` TEXT NOT NULL
, `error_string` TEXT NULL
, `snapshot_uid` TEXT NOT NULL
, `name` TEXT NULL, `parent_name` TEXT NULL, `error_code` TEXT NULL);
CREATE TABLE `user_external_session` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `user_auth_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `auth_module` TEXT NOT NULL
, `access_token` TEXT NULL
, `id_token` TEXT NULL
, `refresh_token` TEXT NULL
, `session_id` TEXT NULL
, `session_id_hash` TEXT NULL
, `name_id` TEXT NULL
, `name_id_hash` TEXT NULL
, `expires_at` DATETIME NULL
, `created_at` DATETIME NOT NULL
);
CREATE TABLE `resource_migration_log` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `migration_id` TEXT NOT NULL
, `sql` TEXT NOT NULL
, `success` INTEGER NOT NULL
, `error` TEXT NOT NULL
, `timestamp` DATETIME NOT NULL
);
INSERT INTO resource_migration_log VALUES(1,'create resource_migration_log table',replace('CREATE TABLE IF NOT EXISTS `resource_migration_log` (\n`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL\n, `migration_id` TEXT NOT NULL\n, `sql` TEXT NOT NULL\n, `success` INTEGER NOT NULL\n, `error` TEXT NOT NULL\n, `timestamp` DATETIME NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(2,'Initialize resource tables','SELECT 0;',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(3,'drop table resource','DROP TABLE IF EXISTS `resource`',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(4,'create table resource',replace('CREATE TABLE IF NOT EXISTS `resource` (\n`guid` TEXT PRIMARY KEY NOT NULL\n, `resource_version` INTEGER NULL\n, `group` TEXT NOT NULL\n, `resource` TEXT NOT NULL\n, `namespace` TEXT NOT NULL\n, `name` TEXT NOT NULL\n, `value` TEXT NULL\n, `action` INTEGER NOT NULL\n, `label_set` TEXT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(5,'create table resource, index: 0','CREATE UNIQUE INDEX `UQE_resource_namespace_group_resource_name` ON `resource` (`namespace`,`group`,`resource`,`name`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(6,'drop table resource_history','DROP TABLE IF EXISTS `resource_history`',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(7,'create table resource_history',replace('CREATE TABLE IF NOT EXISTS `resource_history` (\n`guid` TEXT PRIMARY KEY NOT NULL\n, `resource_version` INTEGER NULL\n, `group` TEXT NOT NULL\n, `resource` TEXT NOT NULL\n, `namespace` TEXT NOT NULL\n, `name` TEXT NOT NULL\n, `value` TEXT NULL\n, `action` INTEGER NOT NULL\n, `label_set` TEXT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(8,'create table resource_history, index: 0','CREATE UNIQUE INDEX `UQE_resource_history_namespace_group_name_version` ON `resource_history` (`namespace`,`group`,`resource`,`name`,`resource_version`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(9,'create table resource_history, index: 1','CREATE INDEX `IDX_resource_history_resource_version` ON `resource_history` (`resource_version`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(10,'drop table resource_version','DROP TABLE IF EXISTS `resource_version`',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(11,'create table resource_version',replace('CREATE TABLE IF NOT EXISTS `resource_version` (\n`group` TEXT NOT NULL\n, `resource` TEXT NOT NULL\n, `resource_version` INTEGER NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(12,'create table resource_version, index: 0','CREATE UNIQUE INDEX `UQE_resource_version_group_resource` ON `resource_version` (`group`,`resource`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(13,'drop table resource_blob','DROP TABLE IF EXISTS `resource_blob`',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(14,'create table resource_blob',replace('CREATE TABLE IF NOT EXISTS `resource_blob` (\n`uuid` UUID PRIMARY KEY NOT NULL\n, `created` DATETIME NOT NULL\n, `group` TEXT NOT NULL\n, `resource` TEXT NOT NULL\n, `namespace` TEXT NOT NULL\n, `name` TEXT NOT NULL\n, `value` BLOB NOT NULL\n, `hash` TEXT NOT NULL\n, `content_type` TEXT NOT NULL\n);','\n',char(10)),1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(15,'create table resource_blob, index: 0','CREATE INDEX `IDX_resource_history_namespace_group_name` ON `resource_blob` (`namespace`,`group`,`resource`,`name`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(16,'create table resource_blob, index: 1','CREATE INDEX `IDX_resource_blob_created` ON `resource_blob` (`created`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(17,'Add column previous_resource_version in resource_history','alter table `resource_history` ADD COLUMN `previous_resource_version` INTEGER NULL ',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(18,'Add column previous_resource_version in resource','alter table `resource` ADD COLUMN `previous_resource_version` INTEGER NULL ',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(19,'Add index to resource_history for polling','CREATE INDEX `IDX_resource_history_group_resource_resource_version` ON `resource_history` (`group`,`resource`,`resource_version`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(20,'Add index to resource for loading','CREATE INDEX `IDX_resource_group_resource` ON `resource` (`group`,`resource`);',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(21,'Add column folder in resource_history','alter table `resource_history` ADD COLUMN `folder` TEXT NOT NULL DEFAULT '''' ',1,'','2025-05-23 21:43:15');
INSERT INTO resource_migration_log VALUES(22,'Add column folder in resource','alter table `resource` ADD COLUMN `folder` TEXT NOT NULL DEFAULT '''' ',1,'','2025-05-23 21:43:15');
CREATE TABLE `resource` (
`guid` TEXT PRIMARY KEY NOT NULL
, `resource_version` INTEGER NULL
, `group` TEXT NOT NULL
, `resource` TEXT NOT NULL
, `namespace` TEXT NOT NULL
, `name` TEXT NOT NULL
, `value` TEXT NULL
, `action` INTEGER NOT NULL
, `label_set` TEXT NULL
, `previous_resource_version` INTEGER NULL, `folder` TEXT NOT NULL DEFAULT '');
CREATE TABLE `resource_history` (
`guid` TEXT PRIMARY KEY NOT NULL
, `resource_version` INTEGER NULL
, `group` TEXT NOT NULL
, `resource` TEXT NOT NULL
, `namespace` TEXT NOT NULL
, `name` TEXT NOT NULL
, `value` TEXT NULL
, `action` INTEGER NOT NULL
, `label_set` TEXT NULL
, `previous_resource_version` INTEGER NULL, `folder` TEXT NOT NULL DEFAULT '');
CREATE TABLE `resource_version` (
`group` TEXT NOT NULL
, `resource` TEXT NOT NULL
, `resource_version` INTEGER NOT NULL
);
CREATE TABLE `resource_blob` (
`uuid` UUID PRIMARY KEY NOT NULL
, `created` DATETIME NOT NULL
, `group` TEXT NOT NULL
, `resource` TEXT NOT NULL
, `namespace` TEXT NOT NULL
, `name` TEXT NOT NULL
, `value` BLOB NOT NULL
, `hash` TEXT NOT NULL
, `content_type` TEXT NOT NULL
);
INSERT INTO sqlite_sequence VALUES('migration_log',629);
INSERT INTO sqlite_sequence VALUES('user',1);
INSERT INTO sqlite_sequence VALUES('temp_user',0);
INSERT INTO sqlite_sequence VALUES('dashboard',3);
INSERT INTO sqlite_sequence VALUES('dashboard_provisioning',0);
INSERT INTO sqlite_sequence VALUES('api_key',0);
INSERT INTO sqlite_sequence VALUES('plugin_setting',0);
INSERT INTO sqlite_sequence VALUES('alert_rule_tag',0);
INSERT INTO sqlite_sequence VALUES('annotation_tag',0);
INSERT INTO sqlite_sequence VALUES('dashboard_version',4);
INSERT INTO sqlite_sequence VALUES('dashboard_acl',2);
INSERT INTO sqlite_sequence VALUES('login_attempt',2);
INSERT INTO sqlite_sequence VALUES('seed_assignment',0);
INSERT INTO sqlite_sequence VALUES('folder',1);
INSERT INTO sqlite_sequence VALUES('kv_store',9);
INSERT INTO sqlite_sequence VALUES('cloud_migration_session',0);
INSERT INTO sqlite_sequence VALUES('cloud_migration_snapshot',0);
INSERT INTO sqlite_sequence VALUES('org',1);
INSERT INTO sqlite_sequence VALUES('org_user',1);
INSERT INTO sqlite_sequence VALUES('resource_migration_log',22);
INSERT INTO sqlite_sequence VALUES('alert_configuration',1);
INSERT INTO sqlite_sequence VALUES('alert_configuration_history',2);
INSERT INTO sqlite_sequence VALUES('server_lock',3);
INSERT INTO sqlite_sequence VALUES('signing_key',1);
INSERT INTO sqlite_sequence VALUES('user_auth_token',1);
INSERT INTO sqlite_sequence VALUES('role',3);
INSERT INTO sqlite_sequence VALUES('user_role',1);
INSERT INTO sqlite_sequence VALUES('permission',113);
INSERT INTO sqlite_sequence VALUES('builtin_role',2);
INSERT INTO sqlite_sequence VALUES('data_source',1);
INSERT INTO sqlite_sequence VALUES('secrets',1);
INSERT INTO sqlite_sequence VALUES('provenance_type',1);
INSERT INTO sqlite_sequence VALUES('alert_rule',4);
INSERT INTO sqlite_sequence VALUES('alert_rule_version',10);
INSERT INTO sqlite_sequence VALUES('annotation',1);
CREATE UNIQUE INDEX `UQE_user_login` ON `user` (`login`);
CREATE UNIQUE INDEX `UQE_user_email` ON `user` (`email`);
CREATE INDEX `IDX_user_login_email` ON `user` (`login`,`email`);
CREATE UNIQUE INDEX `UQE_user_uid` ON `user` (`uid`);
CREATE INDEX `IDX_temp_user_email` ON `temp_user` (`email`);
CREATE INDEX `IDX_temp_user_org_id` ON `temp_user` (`org_id`);
CREATE INDEX `IDX_temp_user_code` ON `temp_user` (`code`);
CREATE INDEX `IDX_temp_user_status` ON `temp_user` (`status`);
CREATE UNIQUE INDEX `UQE_star_user_id_dashboard_id` ON `star` (`user_id`,`dashboard_id`);
CREATE UNIQUE INDEX `UQE_star_user_id_dashboard_uid_org_id` ON `star` (`user_id`,`dashboard_uid`,`org_id`);
CREATE UNIQUE INDEX `UQE_org_name` ON `org` (`name`);
CREATE INDEX `IDX_org_user_org_id` ON `org_user` (`org_id`);
CREATE UNIQUE INDEX `UQE_org_user_org_id_user_id` ON `org_user` (`org_id`,`user_id`);
CREATE INDEX `IDX_org_user_user_id` ON `org_user` (`user_id`);
CREATE INDEX `IDX_dashboard_org_id` ON `dashboard` (`org_id`);
CREATE INDEX `IDX_dashboard_gnet_id` ON `dashboard` (`gnet_id`);
CREATE INDEX `IDX_dashboard_org_id_plugin_id` ON `dashboard` (`org_id`,`plugin_id`);
CREATE INDEX `IDX_dashboard_tag_dashboard_id` ON `dashboard_tag` (`dashboard_id`);
CREATE UNIQUE INDEX `UQE_dashboard_org_id_uid` ON `dashboard` (`org_id`,`uid`);
CREATE INDEX `IDX_dashboard_provisioning_dashboard_id` ON `dashboard_provisioning` (`dashboard_id`);
CREATE INDEX `IDX_dashboard_provisioning_dashboard_id_name` ON `dashboard_provisioning` (`dashboard_id`,`name`);
CREATE INDEX `IDX_dashboard_title` ON `dashboard` (`title`);
CREATE INDEX `IDX_dashboard_is_folder` ON `dashboard` (`is_folder`);
CREATE INDEX `IDX_dashboard_deleted` ON `dashboard` (`deleted`);
CREATE INDEX `IDX_data_source_org_id` ON `data_source` (`org_id`);
CREATE UNIQUE INDEX `UQE_data_source_org_id_name` ON `data_source` (`org_id`,`name`);
CREATE UNIQUE INDEX `UQE_data_source_org_id_uid` ON `data_source` (`org_id`,`uid`);
CREATE INDEX `IDX_data_source_org_id_is_default` ON `data_source` (`org_id`,`is_default`);
CREATE INDEX `IDX_api_key_org_id` ON `api_key` (`org_id`);
CREATE UNIQUE INDEX `UQE_api_key_key` ON `api_key` (`key`);
CREATE UNIQUE INDEX `UQE_api_key_org_id_name` ON `api_key` (`org_id`,`name`);
CREATE UNIQUE INDEX `UQE_dashboard_snapshot_key` ON `dashboard_snapshot` (`key`);
CREATE UNIQUE INDEX `UQE_dashboard_snapshot_delete_key` ON `dashboard_snapshot` (`delete_key`);
CREATE INDEX `IDX_dashboard_snapshot_user_id` ON `dashboard_snapshot` (`user_id`);
CREATE UNIQUE INDEX `UQE_quota_org_id_user_id_target` ON `quota` (`org_id`,`user_id`,`target`);
CREATE UNIQUE INDEX "UQE_plugin_setting_org_id_plugin_id" ON "plugin_setting" ("org_id","plugin_id");
CREATE INDEX `IDX_preferences_org_id` ON `preferences` (`org_id`);
CREATE INDEX `IDX_preferences_user_id` ON `preferences` (`user_id`);
CREATE INDEX `IDX_alert_org_id_id` ON `alert` (`org_id`,`id`);
CREATE INDEX `IDX_alert_state` ON `alert` (`state`);
CREATE INDEX `IDX_alert_dashboard_id` ON `alert` (`dashboard_id`);
CREATE UNIQUE INDEX `UQE_alert_rule_tag_alert_id_tag_id` ON `alert_rule_tag` (`alert_id`,`tag_id`);
CREATE UNIQUE INDEX `UQE_alert_notification_state_org_id_alert_id_notifier_id` ON `alert_notification_state` (`org_id`,`alert_id`,`notifier_id`);
CREATE UNIQUE INDEX `UQE_alert_notification_org_id_uid` ON `alert_notification` (`org_id`,`uid`);
CREATE INDEX `IDX_alert_notification_state_alert_id` ON `alert_notification_state` (`alert_id`);
CREATE INDEX `IDX_alert_rule_tag_alert_id` ON `alert_rule_tag` (`alert_id`);
CREATE INDEX `IDX_annotation_org_id_alert_id` ON `annotation` (`org_id`,`alert_id`);
CREATE INDEX `IDX_annotation_org_id_type` ON `annotation` (`org_id`,`type`);
CREATE UNIQUE INDEX `UQE_annotation_tag_annotation_id_tag_id` ON `annotation_tag` (`annotation_id`,`tag_id`);
CREATE INDEX `IDX_annotation_org_id_created` ON `annotation` (`org_id`,`created`);
CREATE INDEX `IDX_annotation_org_id_updated` ON `annotation` (`org_id`,`updated`);
CREATE INDEX `IDX_annotation_org_id_dashboard_id_epoch_end_epoch` ON `annotation` (`org_id`,`dashboard_id`,`epoch_end`,`epoch`);
CREATE INDEX `IDX_annotation_org_id_epoch_end_epoch` ON `annotation` (`org_id`,`epoch_end`,`epoch`);
CREATE INDEX `IDX_annotation_alert_id` ON `annotation` (`alert_id`);
CREATE INDEX `IDX_dashboard_version_dashboard_id` ON `dashboard_version` (`dashboard_id`);
CREATE UNIQUE INDEX `UQE_dashboard_version_dashboard_id_version` ON `dashboard_version` (`dashboard_id`,`version`);
CREATE INDEX `IDX_team_org_id` ON `team` (`org_id`);
CREATE UNIQUE INDEX `UQE_team_org_id_name` ON `team` (`org_id`,`name`);
CREATE UNIQUE INDEX `UQE_team_org_id_uid` ON `team` (`org_id`,`uid`);
CREATE INDEX `IDX_team_member_org_id` ON `team_member` (`org_id`);
CREATE UNIQUE INDEX `UQE_team_member_org_id_team_id_user_id` ON `team_member` (`org_id`,`team_id`,`user_id`);
CREATE INDEX `IDX_team_member_team_id` ON `team_member` (`team_id`);
CREATE INDEX `IDX_team_member_user_id_org_id` ON `team_member` (`user_id`,`org_id`);
CREATE INDEX `IDX_dashboard_acl_dashboard_id` ON `dashboard_acl` (`dashboard_id`);
CREATE UNIQUE INDEX `UQE_dashboard_acl_dashboard_id_user_id` ON `dashboard_acl` (`dashboard_id`,`user_id`);
CREATE UNIQUE INDEX `UQE_dashboard_acl_dashboard_id_team_id` ON `dashboard_acl` (`dashboard_id`,`team_id`);
CREATE INDEX `IDX_dashboard_acl_user_id` ON `dashboard_acl` (`user_id`);
CREATE INDEX `IDX_dashboard_acl_team_id` ON `dashboard_acl` (`team_id`);
CREATE INDEX `IDX_dashboard_acl_org_id_role` ON `dashboard_acl` (`org_id`,`role`);
CREATE INDEX `IDX_dashboard_acl_permission` ON `dashboard_acl` (`permission`);
CREATE UNIQUE INDEX `UQE_tag_key_value` ON `tag` (`key`,`value`);
CREATE INDEX `IDX_login_attempt_username` ON `login_attempt` (`username`);
CREATE INDEX `IDX_user_auth_auth_module_auth_id` ON `user_auth` (`auth_module`,`auth_id`);
CREATE INDEX `IDX_user_auth_user_id` ON `user_auth` (`user_id`);
CREATE UNIQUE INDEX `UQE_server_lock_operation_uid` ON `server_lock` (`operation_uid`);
CREATE UNIQUE INDEX `UQE_user_auth_token_auth_token` ON `user_auth_token` (`auth_token`);
CREATE UNIQUE INDEX `UQE_user_auth_token_prev_auth_token` ON `user_auth_token` (`prev_auth_token`);
CREATE INDEX `IDX_user_auth_token_user_id` ON `user_auth_token` (`user_id`);
CREATE INDEX `IDX_user_auth_token_revoked_at` ON `user_auth_token` (`revoked_at`);
CREATE UNIQUE INDEX `UQE_cache_data_cache_key` ON `cache_data` (`cache_key`);
CREATE UNIQUE INDEX `UQE_short_url_org_id_uid` ON `short_url` (`org_id`,`uid`);
CREATE INDEX `IDX_alert_instance_rule_org_id_rule_uid_current_state` ON `alert_instance` (`rule_org_id`,`rule_uid`,`current_state`);
CREATE INDEX `IDX_alert_instance_rule_org_id_current_state` ON `alert_instance` (`rule_org_id`,`current_state`);
CREATE UNIQUE INDEX `UQE_alert_rule_org_id_uid` ON `alert_rule` (`org_id`,`uid`);
CREATE INDEX `IDX_alert_rule_org_id_namespace_uid_rule_group` ON `alert_rule` (`org_id`,`namespace_uid`,`rule_group`);
CREATE UNIQUE INDEX `UQE_alert_rule_org_id_namespace_uid_title` ON `alert_rule` (`org_id`,`namespace_uid`,`title`);
CREATE INDEX `IDX_alert_rule_org_id_dashboard_uid_panel_id` ON `alert_rule` (`org_id`,`dashboard_uid`,`panel_id`);
CREATE UNIQUE INDEX `UQE_alert_rule_version_rule_org_id_rule_uid_version` ON `alert_rule_version` (`rule_org_id`,`rule_uid`,`version`);
CREATE INDEX `IDX_alert_rule_version_rule_org_id_rule_namespace_uid_rule_group` ON `alert_rule_version` (`rule_org_id`,`rule_namespace_uid`,`rule_group`);
CREATE UNIQUE INDEX `UQE_ngalert_configuration_org_id` ON `ngalert_configuration` (`org_id`);
CREATE UNIQUE INDEX `UQE_provenance_type_record_type_record_key_org_id` ON `provenance_type` (`record_type`,`record_key`,`org_id`);
CREATE UNIQUE INDEX `UQE_alert_image_token` ON `alert_image` (`token`);
CREATE UNIQUE INDEX `UQE_alert_configuration_org_id` ON `alert_configuration` (`org_id`);
CREATE UNIQUE INDEX `UQE_library_element_org_id_folder_id_name_kind` ON `library_element` (`org_id`,`folder_id`,`name`,`kind`);
CREATE UNIQUE INDEX `UQE_library_element_connection_element_id_kind_connection_id` ON `library_element_connection` (`element_id`,`kind`,`connection_id`);
CREATE UNIQUE INDEX `UQE_library_element_org_id_uid` ON `library_element` (`org_id`,`uid`);
CREATE UNIQUE INDEX `UQE_library_element_org_id_folder_uid_name_kind` ON `library_element` (`org_id`,`folder_uid`,`name`,`kind`);
CREATE UNIQUE INDEX `UQE_kv_store_org_id_namespace_key` ON `kv_store` (`org_id`,`namespace`,`key`);
CREATE INDEX `IDX_permission_role_id` ON `permission` (`role_id`);
CREATE INDEX `IDX_role_org_id` ON `role` (`org_id`);
CREATE UNIQUE INDEX `UQE_role_org_id_name` ON `role` (`org_id`,`name`);
CREATE INDEX `IDX_team_role_org_id` ON `team_role` (`org_id`);
CREATE UNIQUE INDEX `UQE_team_role_org_id_team_id_role_id` ON `team_role` (`org_id`,`team_id`,`role_id`);
CREATE INDEX `IDX_team_role_team_id` ON `team_role` (`team_id`);
CREATE INDEX `IDX_user_role_org_id` ON `user_role` (`org_id`);
CREATE INDEX `IDX_user_role_user_id` ON `user_role` (`user_id`);
CREATE INDEX `IDX_builtin_role_role_id` ON `builtin_role` (`role_id`);
CREATE INDEX `IDX_builtin_role_role` ON `builtin_role` (`role`);
CREATE INDEX `IDX_builtin_role_org_id` ON `builtin_role` (`org_id`);
CREATE UNIQUE INDEX `UQE_builtin_role_org_id_role_id_role` ON `builtin_role` (`org_id`,`role_id`,`role`);
CREATE UNIQUE INDEX `UQE_role_uid` ON `role` (`uid`);
CREATE INDEX `IDX_permission_identifier` ON `permission` (`identifier`);
CREATE UNIQUE INDEX `UQE_permission_action_scope_role_id` ON `permission` (`action`,`scope`,`role_id`);
CREATE UNIQUE INDEX `UQE_user_role_org_id_user_id_role_id_group_mapping_uid` ON `user_role` (`org_id`,`user_id`,`role_id`,`group_mapping_uid`);
CREATE INDEX `IDX_query_history_org_id_created_by_datasource_uid` ON `query_history` (`org_id`,`created_by`,`datasource_uid`);
CREATE UNIQUE INDEX `UQE_query_history_star_user_id_query_uid` ON `query_history_star` (`user_id`,`query_uid`);
CREATE INDEX `IDX_correlation_uid` ON `correlation` (`uid`);
CREATE INDEX `IDX_correlation_source_uid` ON `correlation` (`source_uid`);
CREATE INDEX `IDX_correlation_org_id` ON `correlation` (`org_id`);
CREATE UNIQUE INDEX `UQE_dashboard_public_config_uid` ON "dashboard_public" (`uid`);
CREATE INDEX `IDX_dashboard_public_config_org_id_dashboard_uid` ON "dashboard_public" (`org_id`,`dashboard_uid`);
CREATE UNIQUE INDEX `UQE_dashboard_public_config_access_token` ON "dashboard_public" (`access_token`);
CREATE UNIQUE INDEX `UQE_file_path_hash` ON `file` (`path_hash`);
CREATE INDEX `IDX_file_parent_folder_path_hash` ON `file` (`parent_folder_path_hash`);
CREATE UNIQUE INDEX `UQE_file_meta_path_hash_key` ON `file_meta` (`path_hash`,`key`);
CREATE UNIQUE INDEX `UQE_playlist_org_id_uid` ON `playlist` (`org_id`,`uid`);
CREATE UNIQUE INDEX UQE_seed_assignment_builtin_role_action_scope ON seed_assignment (builtin_role, action, scope);
CREATE UNIQUE INDEX UQE_seed_assignment_builtin_role_role_name ON seed_assignment (builtin_role, role_name);
CREATE UNIQUE INDEX `UQE_folder_org_id_uid` ON `folder` (`org_id`,`uid`);
CREATE UNIQUE INDEX `UQE_anon_device_device_id` ON `anon_device` (`device_id`);
CREATE INDEX `IDX_anon_device_updated_at` ON `anon_device` (`updated_at`);
CREATE UNIQUE INDEX `UQE_signing_key_key_id` ON `signing_key` (`key_id`);
CREATE INDEX `IDX_dashboard_org_id_folder_id_title` ON `dashboard` (`org_id`,`folder_id`,`title`);
CREATE UNIQUE INDEX `UQE_cloud_migration_session_uid` ON `cloud_migration_session` (`uid`);
CREATE UNIQUE INDEX `UQE_cloud_migration_snapshot_uid` ON `cloud_migration_snapshot` (`uid`);
CREATE UNIQUE INDEX `UQE_resource_namespace_group_resource_name` ON `resource` (`namespace`,`group`,`resource`,`name`);
CREATE UNIQUE INDEX `UQE_resource_history_namespace_group_name_version` ON `resource_history` (`namespace`,`group`,`resource`,`name`,`resource_version`);
CREATE INDEX `IDX_resource_history_resource_version` ON `resource_history` (`resource_version`);
CREATE UNIQUE INDEX `UQE_resource_version_group_resource` ON `resource_version` (`group`,`resource`);
CREATE INDEX `IDX_resource_history_namespace_group_name` ON `resource_blob` (`namespace`,`group`,`resource`,`name`);
CREATE INDEX `IDX_resource_blob_created` ON `resource_blob` (`created`);
CREATE INDEX `IDX_resource_history_group_resource_resource_version` ON `resource_history` (`group`,`resource`,`resource_version`);
CREATE INDEX `IDX_resource_group_resource` ON `resource` (`group`,`resource`);
COMMIT;
