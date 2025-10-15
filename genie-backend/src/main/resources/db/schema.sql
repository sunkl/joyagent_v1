CREATE TABLE `chat_model_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(50) NOT NULL COMMENT '模型编码',
  `type` varchar(10) NOT NULL COMMENT '模型类型TABLE,SQL',
  `name` varchar(100) DEFAULT NULL COMMENT '模型名称',
  `content` text NOT NULL COMMENT '模型内容，表或者sql',
  `use_prompt` text COMMENT '模型使用说明',
  `business_prompt` text COMMENT '模型业务限定提示词',
  `yn` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否有效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COMMENT='数据模型表信息';


CREATE TABLE `chat_model_schema` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `model_code` varchar(200)  NOT NULL COMMENT '模型编码',
  `column_id` varchar(1000)  NOT NULL COMMENT '字段唯一ID',
  `column_name` varchar(200)  NOT NULL COMMENT '字段中文名',
  `column_comment` varchar(1000)  NOT NULL COMMENT '字段描述',
  `few_shot` text  COMMENT '值枚举逗号分隔',
  `data_type` varchar(20)  DEFAULT NULL COMMENT '字段值类型',
  `synonyms` varchar(300)  DEFAULT NULL COMMENT '同义词',
  `vector_uuid` varchar(400)  DEFAULT NULL COMMENT '向量库数据id',
  `default_recall` tinyint(2) NOT NULL DEFAULT '0' COMMENT '默认召回',
  `analyze_suggest` tinyint(2) NOT NULL DEFAULT '0' COMMENT '分析建议0可选，-1禁止用于分析维度，1建议',
  `yn` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否有效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COMMENT='数据模型表信息';

CREATE TABLE sales_data (
    row_id INT PRIMARY KEY COMMENT '行 ID',
    order_id VARCHAR(50) DEFAULT NULL COMMENT '订单 ID',
    order_date DATE  COMMENT '订单日期',
    ship_date DATE COMMENT '发货日期',
    ship_mode VARCHAR(50) DEFAULT NULL COMMENT '邮寄方式',
    customer_id VARCHAR(50) DEFAULT NULL COMMENT '客户 ID',
    customer_name VARCHAR(100) DEFAULT NULL COMMENT '客户名称',
    segment VARCHAR(50) DEFAULT NULL COMMENT '细分',
    city VARCHAR(100) DEFAULT NULL COMMENT '城市',
    state_province VARCHAR(100) DEFAULT NULL COMMENT '省/自治区',
    country VARCHAR(100) DEFAULT NULL COMMENT '国家',
    region VARCHAR(50) DEFAULT NULL COMMENT '地区',
    product_id VARCHAR(50) DEFAULT NULL COMMENT '产品 ID',
    category VARCHAR(50) DEFAULT NULL COMMENT '产品类别',
    sub_category VARCHAR(50) DEFAULT NULL COMMENT '产品子类别',
    product_name VARCHAR(255) DEFAULT NULL COMMENT '产品名称',
    sales DECIMAL(10, 4) DEFAULT NULL COMMENT '销售额',
    quantity INT DEFAULT NULL COMMENT '销售数量',
    discount DECIMAL(10, 4) DEFAULT NULL COMMENT '折扣',
    profit DECIMAL(10, 4) DEFAULT NULL COMMENT '利润'
) COMMENT='销售数据表';

CREATE TABLE employee_info (
    employee_id VARCHAR(20) PRIMARY KEY COMMENT '员工ID（主键）',
    full_name VARCHAR(50) NOT NULL COMMENT '员工全名',
    gender VARCHAR(50) COMMENT '性别:男或女',
    nationality VARCHAR(30) COMMENT '国籍',
    id_card VARCHAR(20)  COMMENT '身份证号',
    birth_date VARCHAR(200) NOT NULL COMMENT '出生日期',
    department VARCHAR(50) NOT NULL COMMENT '所属部门',
    marital_status VARCHAR(20)  COMMENT '婚姻状况（未婚,已婚,离异）',
    education VARCHAR(20) COMMENT '最高学历（高中,专科,本科,硕士,博士）',
    contact_phone VARCHAR(15) COMMENT '联系电话',
    emergency_contact VARCHAR(15) COMMENT '紧急联系人电话',
    address VARCHAR(1000) COMMENT '现居住地址',
    hire_date VARCHAR(100) NOT NULL COMMENT '入职日期'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工基础信息表';

CREATE TABLE salary_info (
    salary_id BIGINT PRIMARY KEY  COMMENT '薪酬记录ID',
    employee_id VARCHAR(20) NOT NULL COMMENT '员工ID（用于外键关联employee_info表）',
    grade int NOT NULL COMMENT '薪酬等级（1-15级）',
    level int NOT NULL COMMENT '薪档（1-5档）',
    base_salary int NOT NULL COMMENT '基本工资'
) COMMENT='员工薪酬标准表';

CREATE TABLE employee_attendance (
    attendance_id INT PRIMARY KEY COMMENT '行 ID',
	employee_id int COMMENT '员工ID',
    clock_in_time DATETIME  COMMENT '上班打卡时间',
    clock_out_time DATETIME  COMMENT '下班打卡时间',
    clock_in_type varchar(100) COMMENT '打卡方式（指纹,人脸识别, IC卡, 手机APP, 手动补录)'
) COMMENT='员工打卡信息表';
