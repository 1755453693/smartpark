DROP TABLE IF EXISTS sys_attr;
DROP TABLE IF EXISTS sys_attr_value;
DROP TABLE IF EXISTS sys_dict;
DROP TABLE IF EXISTS sys_dict_item;
DROP TABLE IF EXISTS sys_department;
DROP TABLE IF EXISTS t_res_base_info;
DROP TABLE IF EXISTS t_res_attachment;
DROP TABLE IF EXISTS t_res_purchase;
DROP TABLE IF EXISTS t_res_maintenance;
DROP TABLE IF EXISTS t_res_install_config;
DROP TABLE IF EXISTS t_res_param_config;


-- 属性定义
CREATE TABLE `sys_attr` (
  `attr_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '属性ID',
  `attr_name` varchar(32) NOT NULL COMMENT '属性名称',
  `attr_type` int(10) NOT NULL COMMENT '属性类别，如：文本、数字、邮件、IP地址、下拉框等',
  `data_source` char(1) DEFAULT 1 COMMENT '数据来源，1、属性值表 2、字典表 3、业务表',
	`reg_expression` varchar(200) COMMENT '正则表达式',
	`query_text` varchar(10) COMMENT '数据来源=2时为字典KEY，=3时为业务表SQL',
  `status` char(1) NOT NULL DEFAULT 1 COMMENT '状态，1、有效，0、无效',
	`create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`is_sync` char(1) DEFAULT 0 COMMENT '是否同步，1、是，0、否',
  PRIMARY KEY (`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='属性表';

-- 属性值定义
CREATE TABLE `sys_attr_value` (
  `attr_value_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '属性值ID',
  `attr_id` int(10) NOT NULL COMMENT '属性ID',
  `attr_value` varchar(50) NOT NULL COMMENT '属性值',
  `sort_order` tinyint(3) DEFAULT 1 COMMENT '顺序',
	`is_sync` char(1) DEFAULT 0 COMMENT '是否同步，1、是，0、否',
  PRIMARY KEY (`attr_value_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='属性值表';

-- 字典
CREATE TABLE `sys_dict` (
  `dict_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '字典ID',
  `dict_name` varchar(32) NOT NULL COMMENT '字典名称',
  `dict_desc` varchar(50) COMMENT '字典描述',
  `parent_dict_id` int(10) COMMENT '父级字典ID',
  `status` char(1) NOT NULL DEFAULT 1 COMMENT '状态，1、有效，0、无效',
	`create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`is_sync` char(1) DEFAULT 0 COMMENT '是否同步，1、是，0、否',
  PRIMARY KEY (`dict_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典表';

CREATE TABLE `sys_dict_item` (
  `dict_item_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '字典项ID',
  `dict_id` int(10) NOT NULL COMMENT '字典ID',
  `dict_item_name` varchar(50) COMMENT '字典项值',
  `dict_item_value` varchar(200) COMMENT '字典项值',
  `ext_value1` varchar(100) COMMENT '扩展值1',
  `ext_value2` varchar(100) COMMENT '扩展值2',
  `sort_order` tinyint(1) NOT NULL COMMENT '排序',
	`is_sync` char(1) DEFAULT 0 COMMENT '是否同步，1、是，0、否',
  PRIMARY KEY (`dict_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门';

-- 部门信息
CREATE TABLE `sys_department` (
  `dept_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `dept_name` varchar(32) NOT NULL COMMENT '部门名称',
  `company_id` int(10) NOT NULL COMMENT '公司ID',
  `status` char(1) NOT NULL DEFAULT 1 COMMENT '状态，1、有效，0、无效',
	`create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user_id` int(10) COMMENT '创建人',
	`modify_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `modify_user_id` int(10) COMMENT '修改人',
	`is_sync` char(1) DEFAULT 0 COMMENT '是否同步，1、是，0、否',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门';

-- 菜单SQL
INSERT INTO `sys_menu` (`parent_id`, `name`, `url`, `perms`, `type`, `icon`, `order_num`)
    VALUES ('1', '数据字典管理', 'modules/sys/sysdict.html', NULL, '1', 'fa fa-file-code-o', '6');

-- 按钮父菜单ID
set @parentId = @@identity;

-- 菜单对应按钮SQL
INSERT INTO `sys_menu` (`parent_id`, `name`, `url`, `perms`, `type`, `icon`, `order_num`)
    SELECT @parentId, '查看', null, 'sys:sysdict:list,sys:sysdict:info', '2', null, '6';
INSERT INTO `sys_menu` (`parent_id`, `name`, `url`, `perms`, `type`, `icon`, `order_num`)
    SELECT @parentId, '新增', null, 'sys:sysdict:save', '2', null, '6';
INSERT INTO `sys_menu` (`parent_id`, `name`, `url`, `perms`, `type`, `icon`, `order_num`)
    SELECT @parentId, '修改', null, 'sys:sysdict:update', '2', null, '6';
INSERT INTO `sys_menu` (`parent_id`, `name`, `url`, `perms`, `type`, `icon`, `order_num`)
    SELECT @parentId, '删除', null, 'sys:sysdict:delete', '2', null, '6';