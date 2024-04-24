public class UnityImplementation
{
    ThirdwebSDK sdk;
    private const string petsContractAddress = "0x....."; // The wallet address of the deployed pet contract
    private const string contractAbi = "..."; // The contract abi (Json interface of the contract)

    // Setting up the player wallet 
    public async void playerSetup()
    {
        sdk = ThirdwebManager.Instance.SDK;
        const AuthProvider provider = AuthProvider.Google;
        var connection = new WalletConnection(
            provider: WalletProvider.SmartWallet,
            chainId: 421614,
            personalWallet: WalletProvider.EmbeddedWallet,
            authOptions: new AuthOptions(authProvider: provider)
        );

        await sdk.wallet.Connect(connection);
    }
    
    // Transaction showing a read call to the pet contract
    public void readTransaction()
    {
        const int tokenID = 0;
        var petProperties = getPetProperties(tokenID).Result;
        
        //TODO: Do something with petProperties
    }

    // Transaction showing a write call to the pet contract
    public async void writeTransation()
    {
        var lastTokenID = (await getPetsContract().Read<int>("getLastTokenID"));
        createNewPet();
        var petProperties = await getPetProperties(lastTokenID);
        
        // TODO: Do something with petProperties
    }

    // Helper functions

    private Contract getPetsContract()
    {
        return sdk.GetContract(petsContractAddress, contractAbi);
    }

    private async Task<PetProperties> getPetProperties(int petID)
    {
        return await getPetsContract().Read<PetProperties>("getProperties", petID);
    }

    private async Task<TransactionResult> createNewPet()
    {
        return await getPetsContract().Write("createNewPet");
    }
}