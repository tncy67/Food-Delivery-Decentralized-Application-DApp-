# Food Delivery Decentralized Application (DApp)

A decentralized food delivery application built on Ethereum blockchain, allowing users to register restaurants, browse, and place pickup orders. The smart contract ensures business verification, and users can filter registered restaurants by categories and keywords.

## Features

- Business verification before restaurant registration
- Categories and keywords for filtering restaurants
- Display menu and business hours
- Location-based restaurant listing
- Pickup orders only (no delivery)

## Technologies

- Solidity (Ethereum Smart Contract)
- Python
- Flask
- Web3.py
- HTML, CSS, and JavaScript
- Ganache (local Ethereum test network)

## Prerequisites

- Python 3.x
- Node.js and npm
- Ganache (local Ethereum test network)
- MetaMask (Ethereum wallet)

## Setup

1. Clone this repository:

git clone https://github.com/tncy67/Food-Delivery-Decentralized-Application-DApp-
cd food-delivery-dapp


1. Install required Python packages:

pip install -r requirements.txt


3. Start Ganache and create a new workspace, importing the accounts provided by Ganache into MetaMask.

4. Compile and deploy the smart contract to Ganache:

truffle compile
truffle migrate --reset


5. Update the `app.py` file with the correct contract address and ABI.

6. Run the Flask application:

python app.py


7. Open your browser and navigate to `http://localhost:5000` to use the Food Delivery DApp.

## Usage

1. Verify a business by entering the business' Ethereum address and clicking "Verify Business."

2. Register a restaurant by filling out the registration form and clicking "Register Restaurant."

3. Browse and filter registered restaurants by categories or keywords.

4. View the menu and business hours of a restaurant by clicking on its name.

5. Place a pickup order by selecting items from the restaurant's menu and submitting the order.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


