let contract_a, contract_b, erc20_token

const ContractA = artifacts.require('ContractA')
const ERC20Token = artifacts.require('ERC20Token')
const ContractB = artifacts.require('ContractB');

contract('ContractA', (accounts) => {
    beforeEach(async () => {
        contract_a = await ContractA.new({ from: accounts[0] })
        contract_b = await ContractB.new({ from: accounts[0] })
        erc20_token = await ERC20Token.new({ from: accounts[0] })
    })

    it('creation: is the contract deployer a owner of contract?', async () => {
        const role = await contract_a.isOwner.call(accounts[0])
        assert.equal(true, role)
    })

    it('setAddressOfContractB: set ContractB address, and then check if initialized?', async () => {
        await contract_a.setAddressOfContractB(contract_b.address, { from: accounts[0] })
        const address = await contract_a.getAddressOfContractB.call();
        assert.equal(address, contract_b.address)
    })

    it('deposit: add new 100 amount deposit through ContractA, and then checking balance is 100?', async () => {
        await erc20_token.approve(contract_a.address, 100, { from: accounts[0] })
        await contract_a.setAddressOfContractB(contract_b.address, { from: accounts[0] })
        await contract_b.setAddressOfContractA(contract_a.address, { from: accounts[0] })
        await contract_a.deposit(erc20_token.address, 100, { from: accounts[0] })
        const balance = await contract_b.balanceOf.call(accounts[0], erc20_token.address)
        assert.equal(100, balance)
    })
})

contract('ContractB', (accounts) => {
    beforeEach(async () => {
        contract_b = await ContractB.new({ from: accounts[0] })
        contract_a = await ContractA.new({ from: accounts[0] })
    })

    it('creation: is the contract deployer a owner of contract?', async () => {
        const role = await contract_b.isOwner.call(accounts[0])
        assert.equal(true, role)
    })

    it('addOwner: add account1 as owner and then is account1 a owner of contract?', async () => {
        await contract_b.addOwner(accounts[1], { from: accounts[0] })
        const role = await contract_b.isOwner.call(accounts[1])
        assert.equal(true, role)
    })

    it('setAddressOfContractA: set ContractA address, and then check if initialized?', async () => {
        await contract_b.setAddressOfContractA(contract_a.address, { from: accounts[0] })
        const address = await contract_b.getAddressOfContractA.call();
        assert.equal(address, contract_a.address)
    })

    it('manualRecord: add new deposit manually with account2, and then check balance of account2?', async () => {
        const tokenAddress = "0x4d0Af54E484e896A23f6D0B2068Fd3cc65Ba5F1F";
        await contract_b.manualRecord(accounts[2], tokenAddress, 100, { from: accounts[0] })
        const balance = await contract_b.balanceOf.call(accounts[2], tokenAddress)
        assert.equal(100, balance)
    })

    it('events: is triggered Deposit event whenever calling manualRecord correctly?', async () => {
        const tokenAddress = "0x4d0Af54E484e896A23f6D0B2068Fd3cc65Ba5F1F";
        const res = await contract_b.manualRecord(accounts[2], tokenAddress, 100, { from: accounts[0] })
        const depositLog = res.logs.find(element => element.event.match('Deposit'))
        assert.equal(tokenAddress, depositLog.args._tokenAddress)
        assert.equal(accounts[2], depositLog.args._depositorAddress)
        assert.equal(100, depositLog.args._tokenAmount)
      })
})