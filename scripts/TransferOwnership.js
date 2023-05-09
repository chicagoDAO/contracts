const gnosisSafe = '0x0EdD3EE977bDdf18eAa3548eC8544B78c78F40e5';
const main = async () => {
    try {
        console.log('Transferring ownership of ProxyAdmin...');
        await upgrades.admin.transferProxyAdminOwnership(gnosisSafe);
        console.log('Transferred ownership of ProxyAdmin to:', gnosisSafe);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

main();
