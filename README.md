# SimpleStorage
​
This is a simple Solidity contract that stores a single uint256 value.
​
## Getting Started
​
1. Clone this repository.
2. Install Forge using the instructions found at [https://github.com/foundry-rs/foundry](https://github.com/foundry-rs/foundry).
3. Run the following command to compile the contract:
​
```bash
forge build
```
​
4. Run the following command to deploy the contract to a test network:
​
```bash
forge create
```
​
5. Interact with the contract using Forge's interactive console.
​
```bash
forge console
```
​
## Contributing
​
We welcome contributions to this project. If you're interested in contributing, please open an issue or submit a pull request. 
```
We can preview our `README.md` file in VS Code by going to the `View` menu and selecting `Open Preview to the Side`. This will open a new window showing what the `README.md` file will look like when it's rendered on GitHub.
​
### Using AI for Markdown Formatting
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
