import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from dotenv import load_dotenv
import jwt
from datetime import datetime, timedelta
import hashlib
from functools import wraps

load_dotenv()

app = Flask(__name__)
CORS(app)

# MongoDB setup
client = MongoClient(os.getenv('MONGO_URI'))
db = client['customer_info_db']
users_collection = db['users']
customers_collection = db['customers']

# JWT setup
JWT_SECRET = os.getenv('JWT_SECRET')
JWT_EXPIRATION_DELTA = timedelta(days=1)

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    
    if users_collection.find_one({'email': email}):
        return jsonify({'message': 'User already exists'}), 400
    
    hashed_password = hash_password(password)
    users_collection.insert_one({'email': email, 'password': hashed_password})
    return jsonify({'message': 'User registered successfully'}), 201

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    
    user = users_collection.find_one({'email': email})
    if user and user['password'] == hash_password(password):
        token = jwt.encode({
            'user_id': str(user['_id']),
            'exp': datetime.utcnow() + JWT_EXPIRATION_DELTA
        }, JWT_SECRET, algorithm='HS256')
        return jsonify({'token': token}), 200
    return jsonify({'message': 'Invalid credentials'}), 401

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'message': 'Token is missing'}), 401
        try:
            token = token.split()[1]  # Remove 'Bearer ' prefix
            data = jwt.decode(token, JWT_SECRET, algorithms=['HS256'])
            current_user = users_collection.find_one({'_id': data['user_id']})
        except:
            return jsonify({'message': 'Token is invalid'}), 401
        return f(current_user, *args, **kwargs)
    return decorated

@app.route('/customers', methods=['POST'])
@token_required
def add_customer(current_user):
    data = request.json
    customer = {
        'name': data['name'],
        'email': data['email'],
        'phone': data['phone'],
        'user_id': str(current_user['_id'])
    }
    customers_collection.insert_one(customer)
    return jsonify({'message': 'Customer added successfully'}), 201

@app.route('/customers', methods=['GET'])
@token_required
def get_customers(current_user):
    customers = list(customers_collection.find({'user_id': str(current_user['_id'])}))
    for customer in customers:
        customer['_id'] = str(customer['_id'])
    return jsonify(customers), 200

@app.route('/customers/<customer_id>', methods=['DELETE'])
@token_required
def delete_customer(current_user, customer_id):
    result = customers_collection.delete_one({'_id': customer_id, 'user_id': str(current_user['_id'])})
    if result.deleted_count:
        return jsonify({'message': 'Customer deleted successfully'}), 200
    return jsonify({'message': 'Customer not found'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)