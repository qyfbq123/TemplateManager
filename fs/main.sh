#打包脚本，需在模板库目录下运行
echo 开始打包
mkdir -p _temp
find . -type d -maxdepth 1 -regex '\./[^.[_].*' -exec zip -r ./_temp/{}.zip {} \;
echo 打包结束