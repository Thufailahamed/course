The final project is a bank account. It brings together classes, encapsulation, collections, exceptions and formatting. The rules are simple, but they must be enforced every time: a balance cannot go negative, and a withdrawal larger than the balance must fail.

## Step 1: deposit and withdraw

```java run class
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit must be positive");
        }
        balance += amount;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) {
            return false;
        }
        balance -= amount;
        return true;
    }

    double getBalance() {
        return balance;
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        account.deposit(50);
        System.out.println(account.withdraw(30));
        System.out.println(account.getBalance());
        System.out.println(account.withdraw(500));
        System.out.println(account.getBalance());
    }
}
```

`withdraw` returns a boolean so the caller knows whether the operation happened. The second withdrawal fails and the balance stays `120`.

## Step 2: validate at the boundary

```java run class
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        if (opening < 0) {
            throw new IllegalArgumentException("Opening balance cannot be negative");
        }
        balance = opening;
    }

    void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit must be positive");
        }
        balance += amount;
    }

    void withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal must be positive");
        }
        if (amount > balance) {
            throw new IllegalStateException("Insufficient funds");
        }
        balance -= amount;
    }

    double getBalance() {
        return balance;
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        try {
            account.withdraw(80);
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage());
        }
        System.out.println(account.getBalance());
    }
}
```

Sometimes a boolean is the right signal, sometimes an exception is. Use a boolean for an expected outcome such as "not enough money"; use an exception when the caller has violated the contract, such as a negative deposit.

## Step 3: keep a history

```java run class
import java.util.ArrayList;

class BankAccount {
    private double balance;
    private ArrayList<String> history = new ArrayList<>();

    BankAccount(double opening) {
        balance = opening;
        history.add(String.format("open %.2f", opening));
    }

    void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Deposit must be positive");
        balance += amount;
        history.add(String.format("deposit %.2f", amount));
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        history.add(String.format("withdraw %.2f", amount));
        return true;
    }

    void printHistory() {
        for (String entry : history) {
            System.out.println(entry);
        }
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        account.deposit(25);
        account.withdraw(40);
        account.withdraw(500);
        account.printHistory();
        System.out.println(String.format("Balance: %.2f", account.getBalance()));
    }
}
```

The failed withdrawal does not appear in the history because it returns before recording anything. Keeping the balance and the history updated in the same method prevents the two from drifting apart.

## Step 4: transfer between accounts

```java run class
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        if (opening < 0) throw new IllegalArgumentException("Negative opening balance");
        balance = opening;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        return true;
    }

    void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Deposit must be positive");
        balance += amount;
    }

    double getBalance() { return balance; }
}

public class Main {
    static boolean transfer(BankAccount from, BankAccount to, double amount) {
        if (!from.withdraw(amount)) {
            return false;
        }
        to.deposit(amount);
        return true;
    }

    public static void main(String[] args) {
        BankAccount ada = new BankAccount(100);
        BankAccount grace = new BankAccount(20);

        System.out.println(transfer(ada, grace, 30));
        System.out.println(ada.getBalance());
        System.out.println(grace.getBalance());

        System.out.println(transfer(ada, grace, 500));
        System.out.println(ada.getBalance());
        System.out.println(grace.getBalance());
    }
}
```

A transfer is a withdrawal followed by a deposit. Checking the withdrawal first means a failed transfer leaves both accounts untouched. In a real system this would also need a transaction so a crash between the two steps cannot lose money.

```java predict class id=bank-predict title="What is printed?"
class BankAccount {
    private double balance;
    BankAccount(double balance) { this.balance = balance; }
    boolean withdraw(double amount) {
        if (amount > balance) return false;
        balance -= amount;
        return true;
    }
    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        System.out.println(account.withdraw(80) + " " + account.getBalance());
    }
}
--- options
* false 50.0
true 30.0
false 30.0
true 50.0
--- explain
`withdraw(80)` returns `false` and leaves the balance at `50.0`. The string join produces `false 50.0`.
```

## Challenges

```java exercise class id=bank-deposit title="Add a deposit method"
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    // Add deposit(double amount). Reject amounts that are not positive.

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(10);
        account.deposit(5);
        System.out.println(account.getBalance());
    }
}
--- solution
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit must be positive");
        }
        balance += amount;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(10);
        account.deposit(5);
        System.out.println(account.getBalance());
    }
}
--- test
BankAccount account = new BankAccount(10);
account.deposit(5);
__check(Math.abs(account.getBalance() - 15) < 0.0001, "The balance should be 15");
--- hint
Add the amount to `balance` after validating it.
--- hint
`balance += amount;`
```

```java exercise class id=bank-withdraw title="Add a checked withdrawal"
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    // Add boolean withdraw(double amount): false if too large or not positive.

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        System.out.println(account.withdraw(30));
    }
}
--- solution
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) {
            return false;
        }
        balance -= amount;
        return true;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        System.out.println(account.withdraw(30));
    }
}
--- test
BankAccount account = new BankAccount(100);
__check(account.withdraw(30), "A valid withdrawal should succeed");
__check(Math.abs(account.getBalance() - 70) < 0.0001, "The balance should be 70");
__check(!account.withdraw(500), "An overdraft should fail");
--- hint
Check `amount <= 0 || amount > balance` before subtracting.
--- hint
Return `false` for a rejected withdrawal and `true` after a successful one.
```

```java debug class id=fix-withdraw-guard title="The account goes negative"
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    boolean withdraw(double amount) {
        balance -= amount;
        return true;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        System.out.println(account.withdraw(80));
        System.out.println(account.getBalance());
    }
}
--- solution
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) {
            return false;
        }
        balance -= amount;
        return true;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        System.out.println(account.withdraw(80));
        System.out.println(account.getBalance());
    }
}
--- test
BankAccount account = new BankAccount(50);
__check(!account.withdraw(80), "The overdraft should be rejected");
__check(Math.abs(account.getBalance() - 50) < 0.0001, "The balance should stay 50");
--- hint
The method subtracts before checking whether the withdrawal is allowed.
--- hint
Return `false` when `amount > balance`, before changing `balance`.
```
