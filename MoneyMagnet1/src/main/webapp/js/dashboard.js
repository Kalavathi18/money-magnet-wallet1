document.addEventListener("DOMContentLoaded", function () {
    // Confirm before logout
    const logoutButton = document.querySelector(".button[href='logout.jsp']");
    if (logoutButton) {
        logoutButton.addEventListener("click", function (event) {
            const confirmation = confirm("Are you sure you want to logout?");
            if (!confirmation) {
                event.preventDefault(); // Cancel the logout if the user cancels
            }
        });
    }

    // Add hover effect to transaction rows
    const rows = document.querySelectorAll(".transaction-history table tr");
    rows.forEach(row => {
        row.addEventListener("mouseover", function () {
            this.style.backgroundColor = "#f0f0f0"; // Highlight row on hover
        });
        row.addEventListener("mouseout", function () {
            this.style.backgroundColor = ""; // Remove highlight
        });
    });

    // Display total transactions count
    const transactionCount = document.querySelectorAll(".transaction-history table tr").length - 1; // Exclude header row
    if (transactionCount > 0) {
        const countDisplay = document.createElement("p");
        countDisplay.textContent = `Total Transactions: ${transactionCount}`;
        document.querySelector(".transaction-history").prepend(countDisplay); // Display count above the table
    }

    // Validate transfer form
    const transferForm = document.getElementById("transferForm");
    if (transferForm) {
        transferForm.addEventListener("submit", function (event) {
            const amountInput = document.getElementById("transferAmount");
            const recipientInput = document.getElementById("recipient");

            if (!validateAmount(amountInput.value)) {
                alert("Please enter a valid transfer amount.");
                event.preventDefault(); // Prevent form submission
                return;
            }

            if (!validateRecipient(recipientInput.value)) {
                alert("Please enter a valid recipient.");
                event.preventDefault(); // Prevent form submission
                return;
            }
        });
    }

    // Validate add funds form
    const addFundsForm = document.getElementById("addFundsForm");
    if (addFundsForm) {
        addFundsForm.addEventListener("submit", function (event) {
            const amountInput = document.getElementById("fundsAmount");

            if (!validateAmount(amountInput.value)) {
                alert("Please enter a valid amount to add.");
                event.preventDefault(); // Prevent form submission
            }
        });
    }

    // Helper functions for validation
    function validateAmount(amount) {
        const num = parseFloat(amount);
        return !isNaN(num) && num > 0;
    }

    function validateRecipient(recipient) {
        return recipient && recipient.trim().length > 0;
    }
});
// js/dashboard.js

function validateForm() {
    const recipient = document.getElementById("recipient").value;
    const amount = document.getElementById("transferAmount").value;

    if (!recipient || recipient.trim() === "") {
        alert("Please enter a valid recipient.");
        return false;
    }

    if (amount <= 0) {
        alert("Please enter a valid amount greater than zero.");
        return false;
    }

    return true; // Allow form submission if validation passes
}

document.getElementById('addFundsForm').addEventListener('submit', function(event) {
    const amount = document.getElementById('fundsAmount').value;
    if (amount <= 0) {
        alert("Please enter a valid amount greater than zero.");
        event.preventDefault(); // Prevents form submission if validation fails
    }
});
