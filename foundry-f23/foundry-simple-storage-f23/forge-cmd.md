anvil: 启动anvil服务，生成账号和密钥

forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key $PRIVATE_KEY: 部署合约，获取合约地址（0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512）

forge create: 用于部署合约，需要提供合约路径、构造函数参数和部署选项，例如：
forge create src/SimpleStorage.sol:SimpleStorage --constructor-args 123 --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY

cast send: 用于签名和发送交易，需要提供合约地址、函数签名和参数，例如：
cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "store(uint256)" 123 --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY

cast call: 用于读取区块链上存储信息，需要提供合约地址、函数签名和参数，例如：
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "retrieve()" --rpc-url http://127.0.0.1:8545

cast --to-base 0x714e1 dec 十六进制转十进制