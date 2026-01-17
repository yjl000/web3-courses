1、vm.expectRevert() // 期望下一个交易会revert
2、vm.prank() // 设置为下一次调用的指定地址
3、vm.startPrank() // 设置为下一次调用的指定地址, 直到调用vm.stopPrank()才会恢复
4、vm.stopPrank() // 停止startPrank()的设置。
5、makeAddr() // 创建新的用户地址
6、vm.deal(alice, 100 ether) // 为alice设置初始余额
7、hoax() // = deal+prank
8、vm.txGasPrice // 为下一笔交易设置gas价格
9、vm.load(address, bytes32) // 加载合约存储中的数据
10、vm.expectEmit() // 期望下一个交易会emit指定事件 
```js
function expectEmit( 
  bool checkTopic1,  // 布尔值 checkTopic1,
  bool checkTopic2,  // 布尔值 checkTopic2,
  bool checkTopic3,  // 布尔值 checkTopic3,
  bool checkData,  //布尔值 checkData（非indexed参数）,
  address emitter 
) external;

event EnteredRaffle(address indexed player);
vm.expectEmit(true, false, false, false, address(raffle)); // 只有indexed一个参数，
```

vm.warp(block.timestamp + interval + 1); // 为下一笔交易设置时间戳
vm.roll(block.number + 1); // 为下一笔交易设置区块号

