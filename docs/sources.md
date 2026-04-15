# Source tables

This document lists the source tables and their columns.

## CUSTOMER
- C_CUSTKEY  
- C_NAME  
- C_ADDRESS  
- C_NATIONKEY  
- C_PHONE  
- C_ACCTBAL  
- C_MKTSEGMENT  
- C_COMMENT

## LINEITEM
- L_ORDERKEY  
- L_PARTKEY  
- L_SUPPKEY  
- L_LINENUMBER  
- L_QUANTITY  
- L_EXTENDEDPRICE  
- L_DISCOUNT  
- L_TAX  
- L_RETURNFLAG  
- L_LINESTATUS  
- L_SHIPDATE  
- L_COMMITDATE  
- L_RECEIPTDATE  
- L_SHIPINSTRUCT  
- L_SHIPMODE  
- L_COMMENT

## NATION
- N_NATIONKEY  
- N_NAME  
- N_REGIONKEY  
- N_COMMENT

## ORDERS
- O_ORDERKEY  
- O_CUSTKEY  
- O_ORDERSTATUS  
- O_TOTALPRICE  
- O_ORDERDATE  
- O_ORDERPRIORITY  
- O_CLERK  
- O_SHIPPRIORITY  
- O_COMMENT

## PART
- P_PARTKEY  
- P_NAME  
- P_MFGR  
- P_BRAND  
- P_TYPE  
- P_SIZE  
- P_CONTAINER  
- P_RETAILPRICE  
- P_COMMENT

## PARTSUPP
- PS_PARTKEY  
- PS_SUPPKEY  
- PS_AVAILQTY  
- PS_SUPPLYCOST  
- PS_COMMENT

## REGION
- R_REGIONKEY  
- R_NAME  
- R_COMMENT

## SUPPLIER
- S_SUPPKEY  
- S_NAME  
- S_ADDRESS  
- S_NATIONKEY  
- S_PHONE  
- S_ACCTBAL  
- S_COMMENT

---

## Source ER diagram (Mermaid)

```mermaid
erDiagram
	REGION ||--o{ NATION : "contains"
	NATION ||--o{ CUSTOMER : "is home of"
	NATION ||--o{ SUPPLIER : "is home of"
	CUSTOMER ||--o{ ORDERS : "places"
	ORDERS ||--o{ LINEITEM : "includes"
	PART ||--o{ LINEITEM : "is sold in"
	SUPPLIER ||--o{ LINEITEM : "ships"
	PART ||--o{ PARTSUPP : "is supplied by"
	SUPPLIER ||--o{ PARTSUPP : "supplies"

	CUSTOMER {
		int C_CUSTKEY PK
		string C_NAME
		string C_ADDRESS
		int C_NATIONKEY FK
		string C_PHONE
		float C_ACCTBAL
		string C_MKTSEGMENT
		string C_COMMENT
	}

	LINEITEM {
		int L_ORDERKEY FK
		int L_PARTKEY FK
		int L_SUPPKEY FK
		int L_LINENUMBER PK
		float L_QUANTITY
		float L_EXTENDEDPRICE
		float L_DISCOUNT
		float L_TAX
		string L_RETURNFLAG
		string L_LINESTATUS
		date L_SHIPDATE
		date L_COMMITDATE
		date L_RECEIPTDATE
		string L_SHIPINSTRUCT
		string L_SHIPMODE
		string L_COMMENT
	}

	NATION {
		int N_NATIONKEY PK
		string N_NAME
		int N_REGIONKEY FK
		string N_COMMENT
	}

	ORDERS {
		int O_ORDERKEY PK
		int O_CUSTKEY FK
		string O_ORDERSTATUS
		float O_TOTALPRICE
		date O_ORDERDATE
		string O_ORDERPRIORITY
		string O_CLERK
		int O_SHIPPRIORITY
		string O_COMMENT
	}

	PART {
		int P_PARTKEY PK
		string P_NAME
		string P_MFGR
		string P_BRAND
		string P_TYPE
		int P_SIZE
		string P_CONTAINER
		float P_RETAILPRICE
		string P_COMMENT
	}

	PARTSUPP {
		int PS_PARTKEY PK
		int PS_SUPPKEY PK
		int PS_AVAILQTY
		float PS_SUPPLYCOST
		string PS_COMMENT
	}

	REGION {
		int R_REGIONKEY PK
		string R_NAME
		string R_COMMENT
	}

	SUPPLIER {
		int S_SUPPKEY PK
		string S_NAME
		string S_ADDRESS
		int S_NATIONKEY FK
		string S_PHONE
		float S_ACCTBAL
		string S_COMMENT
	}
```