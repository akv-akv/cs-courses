import os

from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    total = 0

    # Query database for all transactions of the user
    data = db.execute("""
                      SELECT transactions.symbol, name, SUM(shares)
                      FROM transactions
                      JOIN symbols ON symbols.symbol = transactions.symbol
                      WHERE user_id=:user_id
                      GROUP BY transactions.symbol
                      HAVING SUM(shares) > 0""", user_id=session['user_id'])

    # Add price and total to the dataset
    for row in data:
        row['price'] = lookup(row['symbol'])['price']
        row['total'] = row['price'] * row['SUM(shares)']
        total += row['total']

    # Counting cash and total
    cash = float(db.execute("""SELECT cash FROM users WHERE id=:user_id""",
                            user_id=session['user_id'])[0]['cash'])
    total += cash

    # Render template with user's portfolio
    return render_template('index.html', rows=data, cash=round(cash, 2), total=round(total, 2))


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""

    # If user reaches route via POST
    if request.method == "POST":
        # Check if symbol is submitted
        if not request.form.get("symbol"):
            return apology("must provide symbol")

        # Check if number of shares is filled and submitted
        if not request.form.get("shares"):
            return apology("must provide number of shares")

        # Lookup for a symbol
        data = lookup(request.form.get("symbol"))

        # If lookup was unsuccessfull, show warning page
        if not data:
            return apology("invalid symbol")

        # Else make necessary transacions
        else:
            # Check if user has enough cash
            cash = db.execute("SELECT cash FROM users WHERE id=:user_id", user_id=session['user_id'])
            purchase_amount = round(float(data['price']) * int(request.form.get("shares")), 2)
            if cash[0]['cash'] < purchase_amount:
                return apology("not enough money")
            else:
                # Reduce cash value by purchase ammount
                db.execute("UPDATE users SET cash=:cash WHERE id=:user_id",
                           cash=cash[0]['cash'] - purchase_amount, user_id=session['user_id'])
                # Insert new record to transactions table
                db.execute("""INSERT INTO transactions (user_id, symbol, shares, price, timestamp)
                           VALUES (:user_id, :symbol, :shares, :price, CURRENT_TIMESTAMP)""",
                           user_id=session['user_id'], symbol=data['symbol'],
                           shares=int(request.form.get("shares")), price=round(float(data['price']), 2))
                # Check if company name is in database:
                name = db.execute("""SELECT * FROM symbols WHERE symbol=:symbol""", symbol=data['symbol'])
                if not name:
                    db.execute("""INSERT INTO symbols (symbol, name)
                               VALUES (:symbol, :name)""",
                               symbol=data['symbol'], name=data['name'])
            return redirect("/")

    # If user reaches route via GET
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    # Query database for all transactions of the user
    data = db.execute("""
                      SELECT transactions.symbol, name, shares, price, timestamp
                      FROM transactions
                      JOIN symbols ON symbols.symbol = transactions.symbol
                      WHERE user_id=:user_id
                      """, user_id=session['user_id'])

    # Render template with query data
    return render_template("history.html", data=data)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = :username",
                          username=request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""

    # If user reached route via POST show quotation results
    if request.method == "POST":

        # Lookup for the symbol with helper function
        data = lookup(request.form.get("symbol"))

        # If None returned then render warning
        if not data:
            return apology("invalid symbol")

        # Else render response template
        else:
            return render_template("quoted.html", name=data['name'],
                                   symbol=request.form.get("symbol"),
                                   price=data['price'])

    # If user reached route via GET show the request form
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # If POST method used then proceed with registration procedure
    if request.method == "POST":

        # Check if username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Check if username doesn't exist in database
        # 1. Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = :username",
                          username=request.form.get("username"))

        # 2. Check if rows is empty, else render warning
        if len(rows) != 0:
            return apology("username already exists", 403)

        # Check if password was submitted
        if not request.form.get("password"):
            return apology("must provide password", 403)

        # Check if confirmation was submitted
        if not request.form.get("confirmation"):
            return apology("must provide password confirmation", 403)

        # Check if password and confirmation are equal
        if request.form.get("password") != request.form.get("confirmation"):
            return apology("confirmation doesn't match password", 403)

        # Insert user data into the database
        db.execute("INSERT INTO users (username, hash) VALUES (:username, :hashed_password)",
                   username=request.form.get("username"),
                   hashed_password=generate_password_hash(request.form.get("password")))

        # Redirect user to
        return redirect("/")

    # If method GET then render template of registration page
    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""

    # If user reached route via POST
    if request.method == "POST":

        # Check if user has enough shares
        symbol = request.form['symbol']
        shares = int(request.form['shares'])
        data = db.execute("""SELECT transactions.symbol, SUM(shares)
                          FROM transactions
                          JOIN symbols ON symbols.symbol = transactions.symbol
                          WHERE user_id=:user_id AND transactions.symbol=:symbol
                          GROUP BY transactions.symbol""", user_id=session['user_id'],
                          symbol=symbol)
        if data[0]['SUM(shares)'] < shares:
            return apology("not enough shares")
        elif shares < 1:
            return apology("number of shares not valid")
        else:
            # Lookup for price
            price = float(lookup(symbol)['price'])

            # Add price * shares to user cash
            purchase_amount = round(price * shares, 2)
            cash = db.execute("SELECT cash FROM users WHERE id=:user_id", user_id=session['user_id'])
            db.execute("UPDATE users SET cash=:cash WHERE id=:user_id",
                       cash=cash[0]['cash'] + purchase_amount, user_id=session['user_id'])

            # Insert new record to transactions table
            db.execute("""INSERT INTO transactions (user_id, symbol, shares, price, timestamp)
                       VALUES (:user_id, :symbol, :shares, :price, CURRENT_TIMESTAMP)""",
                       user_id=session['user_id'], symbol=symbol,
                       shares=-shares, price=price)
            return redirect("/")

    # If user reached route via GET
    else:
        # Query database for all transactions of the user
        data = db.execute("""SELECT transactions.symbol, SUM(shares)
                          FROM transactions
                          JOIN symbols ON symbols.symbol = transactions.symbol
                          WHERE user_id=:user_id
                          GROUP BY transactions.symbol""", user_id=session['user_id'])

        if not data:
            return apology("nothing to sell")
        else:
            return render_template("sell.html", symbols=data, shares=data)


def errorhandler(e):
    """Handle error"""
    if not isinstance(e, HTTPException):
        e = InternalServerError()
    return apology(e.name, e.code)


# Listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)
