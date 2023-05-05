from flask import Flask, render_template, request, redirect, url_for
from web3 import Web3
import json
import os
from pathlib import Path
from dotenv import load_dotenv
load_dotenv()


app = Flask(__name__)

# Connect to your Ethereum provider (e.g., local Ganache instance)
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB_PROVIDER_URI")))


def load_contract():
    
    with open(Path("abi.json")) as abi:
        contract_abi = json.load(abi)
        
    contract_address = os.getenv("SMART_CONTRACT_DEPLOYED_ADDRESS")
    
    contract = w3.eth.contract(
        address=contract_address,
        abi = contract_abi
    )
    
    return contract

contract = load_contract()

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/register_restaurant', methods=['POST'])
def register_restaurant():
    # Collect the restaurant data from the form
    name = request.form['name']
    location = request.form['location']
    keywords = request.form['keywords'].split(',')
    category = int(request.form['category'])
    menu = request.form['menu']
    open_time = int(request.form['open_time'])
    close_time = int(request.form['close_time'])

    # Call the smart contract function to register the restaurant
    tx_hash = contract.functions.registerRestaurant(
        name, location, keywords, category, menu, open_time, close_time
    ).transact({'from': w3.eth.accounts[0], 'gas': 3000000})

    # Wait for the transaction receipt
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)

    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run()
