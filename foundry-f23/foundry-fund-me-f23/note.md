执行测试用例：
1、forge test
2、forge test --mt testFunctionName
3、forge test --mt testFunctionName --fork-url $SEPOLIA_RPC_URL

测试覆盖率：forge coverage --fork-url $SEPOLIA_RPC_URL

Cheatcodes:

1、vm.expectRevert() // 期望下一个交易会revert
2、vm.prank() // 设置为下一次调用的指定地址
3、vm.startPrank() // 设置为下一次调用的指定地址, 直到调用vm.stopPrank()才会恢复
4、vm.stopPrank() // 停止startPrank()的设置。
5、makeAddr() // 创建新的用户地址
6、vm.deal(alice, 100 ether) // 为alice设置初始余额
7、hoax() // = deal+prank
8、vm.txGasPrice // 为下一笔交易设置gas价格
9、vm.load(address, bytes32) // 加载合约存储中的数据