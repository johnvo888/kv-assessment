const API_URL = process.env.REACT_APP_API_URL;

// Authentication
async function login(email, password) {
    const response = await fetch(`${API_URL}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password })
    });
    if (response.ok) {
        const data = await response.json();
        localStorage.setItem('token', data.token);
        showCustomerInfo();
    } else {
        alert('Login failed');
    }
}

async function register(email, password) {
    const response = await fetch(`${API_URL}/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password })
    });
    if (response.ok) {
        alert('Registration successful. Please login.');
    } else {
        alert('Registration failed');
    }
}

// Customer Information
async function addCustomer(name, email, phone) {
    const token = localStorage.getItem('token');
    const response = await fetch(`${API_URL}/customers`, {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ name, email, phone })
    });
    if (response.ok) {
        fetchCustomers();
    } else {
        alert('Failed to add customer');
    }
}

async function fetchCustomers() {
    const token = localStorage.getItem('token');
    const response = await fetch(`${API_URL}/customers`, {
        headers: { 'Authorization': `Bearer ${token}` }
    });
    if (response.ok) {
        const customers = await response.json();
        displayCustomers(customers);
    } else {
        alert('Failed to fetch customers');
    }
}

function displayCustomers(customers) {
    const customerList = document.getElementById('customer-list');
    customerList.innerHTML = '';
    customers.forEach(customer => {
        const customerElement = document.createElement('div');
        customerElement.classList.add('customer-item');
        customerElement.innerHTML = `
            <p>Name: ${customer.name}</p>
            <p>Email: ${customer.email}</p>
            <p>Phone: ${customer.phone}</p>
            <button onclick="deleteCustomer('${customer._id}')">Delete</button>
        `;
        customerList.appendChild(customerElement);
    });
}

async function deleteCustomer(id) {
    const token = localStorage.getItem('token');
    const response = await fetch(`${API_URL}/customers/${id}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${token}` }
    });
    if (response.ok) {
        fetchCustomers();
    } else {
        alert('Failed to delete customer');
    }
}

// UI Functions
function showCustomerInfo() {
    document.getElementById('auth-container').style.display = 'none';
    document.getElementById('customer-info-container').style.display = 'block';
    fetchCustomers();
}

// Event Listeners
document.getElementById('login-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const email = document.getElementById('login-email').value;
    const password = document.getElementById('login-password').value;
    login(email, password);
});

document.getElementById('register-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const email = document.getElementById('register-email').value;
    const password = document.getElementById('register-password').value;
    register(email, password);
});

document.getElementById('customer-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const name = document.getElementById('customer-name').value;
    const email = document.getElementById('customer-email').value;
    const phone = document.getElementById('customer-phone').value;
    addCustomer(name, email, phone);
});