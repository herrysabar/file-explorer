/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80030
 Source Host           : localhost:3306
 Source Schema         : file_explorer_db

 Target Server Type    : MySQL
 Target Server Version : 80030
 File Encoding         : 65001

 Date: 11/08/2025 08:19:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for nodes
-- ----------------------------
DROP TABLE IF EXISTS `nodes`;
CREATE TABLE `nodes`  (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `parent_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` enum('folder','file') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_nodes_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_nodes_type`(`type` ASC) USING BTREE,
  CONSTRAINT `nodes_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `nodes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of nodes
-- ----------------------------
INSERT INTO `nodes` VALUES ('a1b2c3d4-0001-4001-8001-111111111111', NULL, 'Documents', 'folder', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('a1b2c3d4-0002-4002-8002-222222222222', NULL, 'Pictures', 'folder', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('a1b2c3d4-0003-4003-8003-333333333333', NULL, 'system32', 'folder', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('a1b2c3d4-0004-4004-8004-444444444444', 'a1b2c3d4-0001-4001-8001-111111111111', 'Work', 'folder', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('a1b2c3d4-0005-4005-8005-555555555555', 'a1b2c3d4-0001-4001-8001-111111111111', 'Personal', 'folder', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('ag25iwfg5yrtpzwqkd68rq38', 'a1b2c3d4-0002-4002-8002-222222222222', 'delta', 'folder', '2025-08-11 07:44:44', '2025-08-11 07:44:44');
INSERT INTO `nodes` VALUES ('bmvd2cazh2pqjxtdx5gptjrf', 'a1b2c3d4-0001-4001-8001-111111111111', 'test', 'folder', '2025-08-10 19:42:21', '2025-08-10 19:42:21');
INSERT INTO `nodes` VALUES ('c5956koek3adg1lopfw9o0f5', 'a1b2c3d4-0003-4003-8003-333333333333', 'test', 'folder', '2025-08-10 19:42:51', '2025-08-10 19:42:51');
INSERT INTO `nodes` VALUES ('ebco9ia0xiys0lertgiwieix', 'a1b2c3d4-0002-4002-8002-222222222222', 'beta', 'folder', '2025-08-11 07:44:38', '2025-08-11 07:44:38');
INSERT INTO `nodes` VALUES ('eih5bomx2xz88je8gabnfza9', 'a1b2c3d4-0002-4002-8002-222222222222', 'alpha', 'folder', '2025-08-11 07:44:35', '2025-08-11 07:44:35');
INSERT INTO `nodes` VALUES ('f1f2f3f4-0001-4001-8001-111111111111', 'a1b2c3d4-0004-4004-8004-444444444444', 'report.docx', 'file', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('f1f2f3f4-0002-4002-8002-222222222222', 'a1b2c3d4-0005-4005-8005-555555555555', 'todos.txt', 'file', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('f1f2f3f4-0003-4003-8003-333333333333', 'a1b2c3d4-0002-4002-8002-222222222222', 'vacation.jpg', 'file', '2025-08-10 16:46:43', '2025-08-10 16:46:43');
INSERT INTO `nodes` VALUES ('f7l0eebu4qqx07sz8oo0vo9c', 's1fehemz421p7ikxm8ayphmv', 'test', 'folder', '2025-08-10 19:42:39', '2025-08-10 19:42:39');
INSERT INTO `nodes` VALUES ('foqfcvrj6xv0r14bh5kthdj6', 'a1b2c3d4-0002-4002-8002-222222222222', 'gamma', 'folder', '2025-08-11 07:44:41', '2025-08-11 07:44:41');
INSERT INTO `nodes` VALUES ('nb1ujwz52l5c4pskx2qvk4ab', 'a1b2c3d4-0002-4002-8002-222222222222', 'test1', 'folder', '2025-08-11 07:44:30', '2025-08-11 07:44:30');
INSERT INTO `nodes` VALUES ('s1fehemz421p7ikxm8ayphmv', 'a1b2c3d4-0002-4002-8002-222222222222', 'test', 'folder', '2025-08-10 19:42:34', '2025-08-10 19:42:34');
INSERT INTO `nodes` VALUES ('tv4377tu2k91gnehbjkvkitn', 'f7l0eebu4qqx07sz8oo0vo9c', 'test', 'folder', '2025-08-10 19:42:44', '2025-08-10 19:42:44');

SET FOREIGN_KEY_CHECKS = 1;
