# build.sh
#!/usr/bin/env bash
set -euo pipefail

# 需安装 jdk17 (容器内基础镜像已提供 openjdk-17)
# 需安装 maven3 (基础镜像 maven:3.8-openjdk-17 已包含)

# 生成临时 settings（使用阿里云镜像加速）
cat > aliyun-settings.xml <<'EOF'
<settings>
  <mirrors>
    <mirror>
      <id>aliyun</id>
      <url>https://maven.aliyun.com/repository/public</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
EOF

echo "[build.sh] Using mirror settings, start maven build..."
mvn -B -DskipTests -s aliyun-settings.xml clean package
echo "[build.sh] Maven build finished."
