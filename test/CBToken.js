const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CubeToken Contract", function () {
    let cbToken;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        const CubeToken = await ethers.getContractFactory("CubeToken");
        cbToken = await CubeToken.deploy();
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await cbToken.owner()).to.equal(owner.address);
        });

        it("Should assign the total supply of tokens to the owner", async function () {
            const ownerBalance = await cbToken.balanceOf(owner.address);
            expect(await cbToken.totalSupply()).to.equal(ownerBalance);
        });
    });

    describe("Transactions", function () {
        it("Should transfer tokens between accounts", async function () {
            await cbToken.transfer(addr1.address, 50);
            const addr1Balance = await cbToken.balanceOf(addr1.address);
            expect(addr1Balance).to.equal(50);
        });

        it("Should fail if sender doesn’t have enough tokens", async function () {
            const initialOwnerBalance = await cbToken.balanceOf(owner.address);
            await expect(cbToken.connect(addr1).transfer(owner.address, 1)).to.be.revertedWith("Insufficient balance");
            expect(await cbToken.balanceOf(owner.address)).to.equal(initialOwnerBalance);
        });

        it("Should update balances after transfers", async function () {
            const initialOwnerBalance = await cbToken.balanceOf(owner.address);
            await cbToken.transfer(addr1.address, 100);
            await cbToken.transfer(addr2.address, 50);

            const finalOwnerBalance = await cbToken.balanceOf(owner.address);
            const addr1Balance = await cbToken.balanceOf(addr1.address);
            const addr2Balance = await cbToken.balanceOf(addr2.address);

            expect(finalOwnerBalance).to.equal(initialOwnerBalance - 150n);
            expect(addr1Balance).to.equal(100n);
            expect(addr2Balance).to.equal(50n);
        });
    });

    describe("Approvals", function () {
        it("Should correctly set allowance for delegated transfer", async function () {
            await cbToken.approve(addr1.address, 100);
            const allowance = await cbToken.allowance(owner.address, addr1.address);
            expect(allowance).to.equal(100);
        });

        it("Should allow delegated transfers", async function () {
            await cbToken.approve(addr1.address, 100);
            await cbToken.connect(addr1).transferFrom(owner.address, addr2.address, 100);
            const balance = await cbToken.balanceOf(addr2.address);
            expect(balance).to.equal(100);
        });
    });

    describe("Minting and Burning", function () {
        it("Should mint new tokens and increase total supply", async function () {
            const initialSupply = await cbToken.totalSupply();
            await cbToken.mint(1000);
            const newSupply = await cbToken.totalSupply();
            expect(newSupply).to.equal(initialSupply + 1000n);
        });

        it("Should burn tokens and decrease total supply", async function () {
            await cbToken.mint(1000);
            const initialSupply = await cbToken.totalSupply();
            await cbToken.burn(1000);
            const newSupply = await cbToken.totalSupply();
            expect(newSupply).to.equal(initialSupply - 1000n);
        });
    });

    describe("Pausing and Unpausing", function () {
        it("Should pause and unpause the contract", async function () {
            await cbToken.pause();
            await expect(cbToken.transfer(addr1.address, 100)).to.be.revertedWith("Contract is paused");

            await cbToken.unpause();
            await cbToken.transfer(addr1.address, 100);
            const balance = await cbToken.balanceOf(addr1.address);
            expect(balance).to.equal(100);
        });
    });
});
