初始化项目
```bash
forge init
// forge init --force
```
安装依赖
```bash
forge install
```

测试所有用例
```bash
forge test
```

分叉测试某个用例
```bash
forge test --mt testfunctionName  --fork-url $Sepolia_RPC_URL
```
计算测试覆盖率
```bash
forge coverage --fork-url $Sepolia_RPC_URL
```