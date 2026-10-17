
-- TABLE 1: MEDICINES
CREATE TABLE medicines (
    medicine_id NUMBER PRIMARY KEY,
    medicine_name VARCHAR2(100) NOT NULL,
    category VARCHAR2(50) NOT NULL,
    reorder_level NUMBER DEFAULT 0 NOT NULL,
    unit_cost NUMBER(10, 2) NOT NULL,

    CONSTRAINT chk_medicine_reorder
        CHECK (reorder_level >= 0),

    CONSTRAINT chk_medicine_cost
        CHECK (unit_cost >= 0)
);

-- TABLE 2: INVENTORY
CREATE TABLE inventory (
    stock_id NUMBER PRIMARY KEY,
    medicine_id NUMBER NOT NULL,
    batch_no VARCHAR2(30) NOT NULL,
    qty_on_hand NUMBER DEFAULT 0 NOT NULL,
    expiry_date DATE NOT NULL,

    CONSTRAINT fk_inventory_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(medicine_id),

    CONSTRAINT chk_inventory_qty
        CHECK (qty_on_hand >= 0),

    CONSTRAINT uq_medicine_batch
        UNIQUE (medicine_id, batch_no)
);

-- TABLE 3: USAGE TRANSACTIONS
CREATE TABLE usage_transactions (
    transaction_id NUMBER PRIMARY KEY,
    medicine_id NUMBER NOT NULL,
    transaction_date DATE NOT NULL,
    qty_used NUMBER NOT NULL,

    CONSTRAINT fk_usage_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(medicine_id),

    CONSTRAINT chk_usage_qty
        CHECK (qty_used > 0)
);
