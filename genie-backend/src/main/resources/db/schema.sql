CREATE TABLE `chat_model_info` (
  `id` BIGINT NOT NULL COMMENT "主键",
  `code` VARCHAR(50) NOT NULL COMMENT "模型编码",
  `type` VARCHAR(10) NOT NULL COMMENT "模型类型TABLE,SQL",
  `name` VARCHAR(100) DEFAULT NULL COMMENT "模型名称",
  `content` STRING NOT NULL COMMENT "模型内容，表或者sql",
  `use_prompt` STRING COMMENT "模型使用说明",
  `business_prompt` STRING COMMENT "模型业务限定提示词",
  `yn` TINYINT NOT NULL DEFAULT "1" COMMENT "是否有效"
) ENGINE=OLAP
UNIQUE KEY(`id`)
COMMENT "数据模型表信息"
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
  "replication_num" = "1",
  "storage_format" = "V2"
);

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
  `yn` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否有效'
) ENGINE=OLAP
UNIQUE KEY(`id`)
COMMENT "数据模型表信息"
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
  "replication_num" = "1",
  "storage_format" = "V2"
);

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
) ENGINE=OLAP
  UNIQUE KEY(`row_id`)
  COMMENT "销售数据表"
  DISTRIBUTED BY HASH(`row_id`) BUCKETS 10
  PROPERTIES (
    "replication_num" = "1",
    "storage_format" = "V2"
  );

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
  ) ENGINE=OLAP
     UNIQUE KEY(`row_id`)
     COMMENT "员工基础信息表"
     DISTRIBUTED BY HASH(`row_id`) BUCKETS 10
     PROPERTIES (
       "replication_num" = "1",
       "storage_format" = "V2"
     );
     CREATE TABLE employee_attendance (
         attendance_id INT PRIMARY KEY COMMENT '行 ID',
     	 employee_id VARCHAR(20) COMMENT '员工ID',
         clock_in_time VARCHAR(20)  COMMENT '上班打卡时间',
         clock_out_time VARCHAR(20)  COMMENT '下班打卡时间',
         clock_in_type varchar(100) COMMENT '打卡方式（指纹,人脸识别, IC卡, 手机APP, 手动补录)'
     )  ENGINE=OLAP
            UNIQUE KEY(`attendance_id`)
            COMMENT "员工打卡信息表"
            DISTRIBUTED BY HASH(`attendance_id`) BUCKETS 10
            PROPERTIES (
              "replication_num" = "1",
              "storage_format" = "V2"
     );

     CREATE TABLE loan_application_route_detail (
         id VARCHAR(1000) NOT NULL COMMENT '主键ID',
         buss_no VARCHAR(1000) COMMENT '支用申请编码',
         crt_time VARCHAR(1000) COMMENT '创建时间',
         actv_amt DOUBLE COMMENT '总金额',
         part_bch_actv_amt DOUBLE COMMENT '资方金额',
         part_bch_cpt_pct DOUBLE COMMENT '资方放款比例',
         channel_no VARCHAR(1000) COMMENT '渠道编码',
         channel_desc VARCHAR(1000) COMMENT '渠道名称',
         bank_id VARCHAR(1000) COMMENT '资方ID',
         bank_name VARCHAR(1000) COMMENT '资方名称',
         bch_cde VARCHAR(1000) COMMENT '机构编码',
         bch_name VARCHAR(1000) COMMENT '机构名称',
         prod_cde VARCHAR(1000) COMMENT '产品编码',
         prod_desc VARCHAR(1000) COMMENT '产品名称',
         third_prod_cde VARCHAR(1000) COMMENT '三级产品编码',
         third_prod_name VARCHAR(1000) COMMENT '三级产品名称',
         second_prod_cde VARCHAR(1000) COMMENT '二级产品编码',
         second_prod_name VARCHAR(1000) COMMENT '二级产品名称',
         first_prod_cde VARCHAR(1000) COMMENT '一级产品编码',
         first_prod_name VARCHAR(1000) COMMENT '一级产品名称',
         buss_typ VARCHAR(1000) COMMENT '业务类型',
         ana_typ_first VARCHAR(1000) COMMENT '分析1级大类',
         ana_typ_second VARCHAR(1000) COMMENT '分析2级大类',
         ana_typ_third VARCHAR(1000) COMMENT '分析3级大类',
         ana_typ_fourth VARCHAR(1000) COMMENT '分析4级大类',
         ana_typ_fifth VARCHAR(1000) COMMENT '分析5级大类',
         shunt_type VARCHAR(1000) COMMENT '推送策略',
         route_priority VARCHAR(1000) COMMENT '路由优先级',
         is_rout_suc BIGINT COMMENT '路由结果,1成功,0失败',
         is_appl BIGINT COMMENT '海尔风控是否审批,1审批,0未审批',
         is_apprv BIGINT COMMENT '海尔风险审批结果,1通过,0未通过',
         is_to_part_appl BIGINT COMMENT '是否应推送资方,1是,0否',
         fltr_apprv VARCHAR(1000) COMMENT '挡板结果,通过/拒绝/未推送',
         is_part_appl BIGINT COMMENT '是否推送资方审批,1推送,0未推送',
         is_part_apprv BIGINT COMMENT '资方审批结果,1通过,0未通过',
         haier_fail_reason VARCHAR(1000) COMMENT '海尔拒绝原因(包含收单拒绝/海尔风控拒绝)',
         bank_fail_reason VARCHAR(1000) COMMENT '资方拒绝原因(包含路由失败/挡板/资方拒绝原因)',
         pay_fail_reason VARCHAR(1000) COMMENT '支付网关失败原因(审批通过但放款失败)',
         actv_sts VARCHAR(1000) COMMENT '审批状态(31放款成功)',
         appl_sts VARCHAR(1000) COMMENT '申请状态:放款成功/放款失败/资方拒绝/挡板拒绝/海消拒绝/路由失败',
         is_haier_suc BIGINT COMMENT '海尔兜底放款',
         cont_no VARCHAR(1000) COMMENT '合同号',
         loan_no VARCHAR(1000) COMMENT '借据号',
         bank_loan_no VARCHAR(1000) COMMENT '资方借据号',
         cust_no VARCHAR(1000) COMMENT '客户编号',
         cust_age DOUBLE COMMENT '用户年龄',
         cust_lvl VARCHAR(1000) COMMENT '用户分层',
         zzx_score DOUBLE COMMENT '中征信评分',
         prvn_name VARCHAR(1000) COMMENT '户籍省份',
         city_name VARCHAR(1000) COMMENT '户籍市',
         batchdate VARCHAR(1000) COMMENT '数据日期'
     ) ENGINE=OLAP
                   UNIQUE KEY(`id`)
                   COMMENT "贷款申请路由与审批明细表"
                   DISTRIBUTED BY HASH(`id`) BUCKETS 10
                   PROPERTIES (
                     "replication_num" = "1",
                     "storage_format" = "V2"
            );

CREATE TABLE inst_loan_paid_pmpl_stat_c (
    stat_dt          VARCHAR(1000) COMMENT '统计日期',
    channel_no       VARCHAR(1000) COMMENT '渠道编号(自营，FX,S9,V8,G9,DE，U1,V3,S9等)',
    channel_desc     VARCHAR(1000) COMMENT '渠道名称(够享借-益通祥产品,自营,还呗API,微众银行,微财,360借条,晓花)',
    prod_cde         VARCHAR(1000) COMMENT '产品编号',
    prod_desc        VARCHAR(1000) COMMENT '产品名称',
    third_prod_cde   VARCHAR(1000) COMMENT '三级产品编码',
    third_prod_name  VARCHAR(1000) COMMENT '三级产品名称',
    buss_typ         VARCHAR(1000) COMMENT '业务类型',
    ana_typ_first    VARCHAR(1000) COMMENT '分析一级',
    ana_typ_second   VARCHAR(1000) COMMENT '分析二级',
    ana_typ_third    VARCHAR(1000) COMMENT '分析三级',
    ana_typ_fourth   VARCHAR(1000) COMMENT '分析四级',
    bank_id          VARCHAR(1000) COMMENT '资方编码',
    bank_name        VARCHAR(1000) COMMENT '资方名称（青岛银行，开泰银行，百信银行，阳光消费金融，中原消费金融，兰州银行）',
    sdic_code        VARCHAR(1000) COMMENT '融担公司编码',
    sdic_name        VARCHAR(1000) COMMENT '融担公司名称',
    self_ps_prcp     DOUBLE        COMMENT '消金应还本金',
    self_ps_int      DOUBLE        COMMENT '消金应还利息',
    self_ps_od_int   DOUBLE        COMMENT '消金应还逾期利息',
    pl_ps_prcp       DOUBLE        COMMENT '资方应还本金',
    pl_ps_int        DOUBLE        COMMENT '资方应还利息',
    pl_ps_od_int     DOUBLE        COMMENT '资方应还逾期利息',
    self_paid_prcp   DOUBLE        COMMENT '消金已还本金',
    self_paid_int    DOUBLE        COMMENT '消金已还利息',
    self_paid_od_int DOUBLE        COMMENT '消金已还逾期利息',
    pl_paid_prcp     DOUBLE        COMMENT '资方已还本金',
    pl_paid_int      DOUBLE        COMMENT '资方已还利息',
    pl_paid_od_int   DOUBLE        COMMENT '资方已还逾期利息'
) ENGINE=OLAP
                    UNIQUE KEY(`channel_no`)
                    COMMENT "贷款还款明细分析表"
                    DISTRIBUTED BY HASH(`channel_no`) BUCKETS 10
                    PROPERTIES (
                      "replication_num" = "1",
                      "storage_format" = "V2"
             );
