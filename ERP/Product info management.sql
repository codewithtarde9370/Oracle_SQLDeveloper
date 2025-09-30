SELECT
    -- =======================
    -- General Information
    -- =======================
    IOP.ORGANIZATION_CODE             "Organisation Code",
    ESIB.ITEM_NUMBER                  "Item Number",
    (SELECT SIT.DESCRIPTION
       FROM EGP_SYSTEM_ITEMS_TL SIT
      WHERE SIT.INVENTORY_ITEM_ID = ESIB.INVENTORY_ITEM_ID
        AND SIT.LANGUAGE = 'US'
        AND ROWNUM = 1)              "Item Description",
    ESIB.INVENTORY_ITEM_STATUS_CODE   "Item Status",
	ESIB.SHELF_LIFE_DAYS               "Life Cycle Phase",
	ESIB.TRADE_ITEM_DESCRIPTOR 			"Pack Type",
    (SELECT EICL.ITEM_CLASS_NAME
       FROM EGP_ITEM_CLASSES_TL EICL
      WHERE EICL.ITEM_CLASS_ID = MSI.ITEM_CATALOG_GROUP_ID
        AND ROWNUM = 1)              "Item Class",
    ESIB.CREATED_BY                   "Created By",
    TO_CHAR(ESIB.CREATION_DATE,'YYYY-MM-DD') "Creation Date",

    -- =======================
    -- Inventory Attributes
    -- =======================
    ESIB.PRIMARY_UOM_CODE             "UOM",
    ESIB.ATTRIBUTE3                   "Display UOM",
	ESIB.ITEM_TYPE  				  "Item Type",
    ESIB.COSTING_ENABLED_FLAG         "Costing Enabled",
	ESIB.DEFAULT_INCLUDE_IN_ROLLUP_FLAG "INCLUDE IN ROLLUP",
    ESIB.INVENTORY_ASSET_FLAG         "Inventory Asset Value",
	
	(SELECT MEANING
       FROM FND_LOOKUP_VALUES_VL
      WHERE LOOKUP_TYPE = 'EGP_PLANNING_MAKE_BUY'
        AND LOOKUP_CODE = ESIB.PLANNING_MAKE_BUY_CODE
        AND ROWNUM = 1)              "Make or Buy",
	ESIB.PLANNER_CODE                 "PLANNER_CODE",	
	
	ESIB.CUM_MANUFACTURING_LEAD_TIME "CUMULATIVE MANUFACTURING",
	ESIB.CUMULATIVE_TOTAL_LEAD_TIME "CUMULATIVE TOTAL",
	ESIB.FORCE_PURCHASE_LEAD_TIME_FLAG "Enforce Purchasing Lead Time",
	ESIB.FIXED_LEAD_TIME    "FIXED LEAD TIME",
	
	ESIB.PREPROCESSING_LEAD_TIME "PREPROCESSING DAYS",
	ESIB.POSTPROCESSING_LEAD_TIME "POSTPROCESSING DAYS",
	ESIB.FULL_LEAD_TIME            "PROCESSING DAYS",
	ESIB.VARIABLE_LEAD_TIME "VARIABLE LEAD TIME",
	 (SELECT MEANING
       FROM FND_LOOKUP_VALUES_VL
      WHERE LOOKUP_TYPE = 'INV_MATERIAL_PLANNING'
        AND LOOKUP_CODE = ESIB.INVENTORY_PLANNING_CODE
        AND ROWNUM = 1)              "Inventory Planning Method",
		
	(SELECT DISPLAY_NAME
       FROM PER_PERSON_NAMES_F PPNF
       JOIN PO_AGENT_ASSIGNMENTS PAA ON PPNF.PERSON_ID = PAA.AGENT_ID
      WHERE PAA.ASSIGNMENT_ID = ESIB.BUYER_ID
        AND ROWNUM = 1)              "Default Buyer",
		
	ESIB.EXPENSE_ACCOUNT               "Expense Account",
	ESIB.HAZARD_CLASS_ID               "Hazard Class",
	ESIB.HAZARDOUS_MATERIAL_FLAG       "Hazardous Material",
	ESIB.INVOICE_MATCH_OPTION          "Invoice Match Option",
	ESIB.LIST_PRICE_PER_UNIT           "List Price",
	ESIB.MATCH_APPROVAL_LEVEL          "Match Approval Level",
	ESIB.PURCHASING_ENABLED_FLAG       "Purchasable",
	ESIB.PURCHASING_ITEM_FLAG          "Purchasing Item",
	ESIB.RECEIVE_CLOSE_TOLERANCE       "Receipt Close Tolerance Percentage",
	(
                                SELECT
                                        PUNT.UN_NUMBER
                                FROM
                                        PO_UN_NUMBERS_TL PUNT
                                WHERE
                                        PUNT.UN_NUMBER_ID=ESIB.UN_NUMBER_ID ) "UN NUMBER" ,
	
	
	ESIB.QTY_RCV_EXCEPTION_CODE        "Receipt Quantity Action",
	ESIB.QTY_RCV_TOLERANCE             "Receipt Quantity Tolerance",
	ESIB.RECEIVING_ROUTING_ID          "Receipt Routing",
	ESIB.BACK_TO_BACK_ENABLED          "BACK-TO-BACK ENABLED",
	(SELECT MEANING
       FROM FND_LOOKUP_VALUES_VL
      WHERE LOOKUP_TYPE = 'EGP_ORDATPCHECKVS_TYPE'
        AND LOOKUP_CODE = ESIB.ATP_FLAG
        AND ROWNUM = 1)              "Check ATP",
	
	ESIB.CUSTOMER_ORDER_FLAG           "Customer Ordered",
	ESIB.CUSTOMER_ORDER_ENABLED_FLAG   "Customer Orders Enabled",
	ESIB.INTERNAL_ORDER_FLAG           "Internally Transferable",
	ESIB.SO_TRANSACTIONS_FLAG          "Order Management Transaction Enabled",
	
	ESIB.RETURNABLE_FLAG              "Returnable",
    ESIB.SHIPPABLE_ITEM_FLAG          "Shippable",
	    -- =======================
    -- WIP Attributes
    -- =======================
    ESIB.BUILD_IN_WIP_FLAG            "Build in WIP",
    ESIB.WIP_SUPPLY_TYPE              "WIP Supply Type",
    ESIB.WIP_SUPPLY_SUBINVENTORY      "WIP Supply Subinventory",
    ESIB.WIP_SUPPLY_LOCATOR_ID        "WIP Supply Locator",
	
	--=======================
    -- Inventory Attributes
    -- =======================
    ESIB.CYCLE_COUNT_ENABLED_FLAG     "Cycle Count Enabled",
    ESIB.INVENTORY_ITEM_FLAG          "Inventory Item",
    ESIB.LOT_CONTROL_CODE             "Lot Control",
    ESIB.RESERVABLE_TYPE              "Reservable",
    ESIB.STOCK_ENABLED_FLAG           "Stocked",
    ESIB.MTL_TRANSACTIONS_ENABLED_FLAG "Transaction Enabled",
   

    (SELECT MEANING
       FROM FND_LOOKUP_VALUES_VL
      WHERE LOOKUP_TYPE = 'EGP_ORDATPCHECKVS_TYPE'
        AND LOOKUP_CODE = ESIB.ATP_COMPONENTS_FLAG
        AND ROWNUM = 1)              "Check ATP Components"

FROM EGP_SYSTEM_ITEMS_B ESIB
JOIN INV_ORG_PARAMETERS IOP
  ON ESIB.ORGANIZATION_ID = IOP.ORGANIZATION_ID
JOIN EGP_SYSTEM_ITEMS_VL MSI
  ON ESIB.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
 AND ESIB.ORGANIZATION_ID = MSI.ORGANIZATION_ID
JOIN HR_ORGANIZATION_UNITS_F_TL HOFT
  ON ESIB.ORGANIZATION_ID = HOFT.ORGANIZATION_ID

WHERE
    IOP.MASTER_ORGANIZATION_ID = '300000004262279'
    AND (:P_ITEM_NUMBER IS NULL OR ESIB.ITEM_NUMBER = :P_ITEM_NUMBER)
    AND (:P_ORG_CODE IS NULL OR IOP.ORGANIZATION_CODE = :P_ORG_CODE)
    AND (:P_ITEM_CLASS IS NULL OR MSI.ITEM_CATALOG_GROUP_ID IN (
            SELECT ITEM_CLASS_ID
            FROM EGP_ITEM_CLASSES_TL
            WHERE ITEM_CLASS_NAME = :P_ITEM_CLASS))
    AND (:P_PLANNER_CODE IS NULL OR ESIB.PLANNER_CODE = :P_PLANNER_CODE)
    AND (:P_BUYER_NAME IS NULL OR EXISTS (
            SELECT 1
            FROM PER_PERSON_NAMES_F PPNF,
                 PO_AGENT_ASSIGNMENTS PAA
            WHERE PPNF.PERSON_ID = PAA.AGENT_ID(+)
              AND PAA.ASSIGNMENT_ID(+) = ESIB.BUYER_ID
              AND PPNF.DISPLAY_NAME = :P_BUYER_NAME))

