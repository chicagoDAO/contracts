const gnosisSafe = '0x0EdD3EE977bDdf18eAa3548eC8544B78c78F40e5';
// open main asynchronous function will handle deployment
const main = async () => {
    try {
        console.log('Transferring ownership of ProxyAdmin...');
        // The owner of the ProxyAdmin can upgrade our contracts
        await upgrades.admin.transferProxyAdminOwnership(gnosisSafe);
        console.log('Transferred ownership of ProxyAdmin to:', gnosisSafe);
        // catch error, if any, and log in console
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

main();
