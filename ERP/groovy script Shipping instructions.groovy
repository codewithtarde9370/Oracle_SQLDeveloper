import oracle.apps.scm.doo.common.extensions.ValidationException
import oracle.apps.scm.doo.common.extensions.Message

Long shipToPartySiteId = header.getAttribute("ShipToPartySiteIdentifier")
Long billToPartySiteId = header.getAttribute("BillToCustomerSiteIdentifier")

// concatenate attributes from a single note object
String concatenateNoteAttributes(def note) {
    if (note == null) return ""
    def parts = []
    for (int i = 1; i <= 6; i++) {
        def attr = note.getAttribute("ContactPointsAttribute" + i)
        if (attr != null && attr.trim()) {
            parts << attr.trim()
        }
    }
    return parts.join(" ")
}

// retrieve all notes
String collectAllNotes(def custAcctContRowSet) {
    if (custAcctContRowSet == null) return ""
    def allNotesList = []
    while (custAcctContRowSet.hasNext()) {
        def row = custAcctContRowSet.next()
        if ("INSTRUCTIONS" == row?.getAttribute("ContactPersonPartyPersonFirstName") && 
            "Attachment" == row?.getAttribute("CustomerAccountContactRoleType")) {
            String custAcctContRelshpId = row?.getAttribute("CustomerAccountContactRelationshipId")
            def notesPVO = context.getViewObject("oracle.apps.cdm.foundation.parties.publicView.analytics.ContactsContactPointsPVO")
            def notesVC = notesPVO.createViewCriteria()
            def notesVCRow = notesVC.createViewCriteriaRow()
            notesVCRow.setAttribute("ContactPointsRelationshipId", custAcctContRelshpId)
            notesVCRow.setAttribute("ContactPointsContactPointType", "WEB")
            notesVCRow.setAttribute("ContactPointsContactPointPurpose", "SHIPPING INSTRUCTIONS")
            def notesRows = notesPVO.findByViewCriteria(notesVC, -1)
            while (notesRows.hasNext()) {
                def noteRec = notesRows.next()
                def noteStr = concatenateNoteAttributes(noteRec)
                if (noteStr) {
                    allNotesList << noteStr
                }
            }
        }
    }
    return allNotesList.join(" ; ")
}

// Get Ship-To site combined notes string
String getShipToSiteNotes(Long pShipToSiteId) {
    def getCustAcctSitePVO = context.getViewObject("oracle.apps.cdm.foundation.parties.publicView.customerAccounts.CustomerAccountSitePVO")
    def getCustAcctSite = getCustAcctSitePVO.createViewCriteria()
    def getCustAcctSiteRow = getCustAcctSite.createViewCriteriaRow()
    getCustAcctSiteRow.setAttribute("PartySiteId", pShipToSiteId)
    def getCustAcctSiteRowSet = getCustAcctSitePVO.findByViewCriteria(getCustAcctSite, 1)
    def CustAcctSiteRec = getCustAcctSiteRowSet.first()
    if (CustAcctSiteRec != null) {
        Long custAcctSiteId = CustAcctSiteRec?.getAttribute("CustAcctSiteId")
        def getCustAcctContPVO = context.getViewObject("oracle.apps.financials.receivables.customers.publicView.analytics.AccountContactPVO")
        def getCustAcctCont = getCustAcctContPVO.createViewCriteria()
        def getCustAcctContRow = getCustAcctCont.createViewCriteriaRow()
        getCustAcctContRow.setAttribute("CustomerAccountContactCustAcctSiteId", custAcctSiteId)
        def getCustAcctContRowSet = getCustAcctContPVO.findByViewCriteria(getCustAcctCont, -1)
        return collectAllNotes(getCustAcctContRowSet)
    }
    return ""
}

// Get Bill-To site combined notes string
String getBillToSiteNotes(Long pBillToSiteId) {
    def getBillToSiteUsePVO = context.getViewObject("oracle.apps.cdm.foundation.parties.publicView.analytics.CustAcctSiteUsePVO")
    def getBillToSiteUse = getBillToSiteUsePVO.createViewCriteria()
    def getBillToSiteUseRow = getBillToSiteUse.createViewCriteriaRow()
    getBillToSiteUseRow.setAttribute("SiteUseId", pBillToSiteId)
    def getBillToSiteUseRowSet = getBillToSiteUsePVO.findByViewCriteria(getBillToSiteUse, 1)
    def getBillToSiteUseRec = getBillToSiteUseRowSet.first()
    if (getBillToSiteUseRec != null) {
        Long partySiteId = getBillToSiteUseRec?.getAttribute("PartySiteId")
        def getBillToSitePVO = context.getViewObject("oracle.apps.cdm.foundation.parties.publicView.customerAccounts.CustomerAccountSitePVO")
        def getBillToSite = getBillToSitePVO.createViewCriteria()
        def getBillToSiteRow = getBillToSite.createViewCriteriaRow()
        getBillToSiteRow.setAttribute("PartySiteId", partySiteId)
        def getBillToSiteRowSet = getBillToSitePVO.findByViewCriteria(getBillToSite, 1)
        def billToSiteRec = getBillToSiteRowSet.first()
        if (billToSiteRec != null) {
            Long custAcctSiteId = billToSiteRec?.getAttribute("CustAcctSiteId")
            def getCustAcctContPVO = context.getViewObject("oracle.apps.financials.receivables.customers.publicView.analytics.AccountContactPVO")
            def getCustAcctCont = getCustAcctContPVO.createViewCriteria()
            def getCustAcctContRow = getCustAcctCont.createViewCriteriaRow()
            getCustAcctContRow.setAttribute("CustomerAccountContactCustAcctSiteId", custAcctSiteId)
            def getCustAcctContRowSet = getCustAcctContPVO.findByViewCriteria(getCustAcctCont, -1)
            return collectAllNotes(getCustAcctContRowSet)
        }
    }
    return ""
}

// Get Customer Account combined notes string
String getAcctNotes(Long pShipToSiteId) {
    def getCustAcctSitePVO = context.getViewObject("oracle.apps.cdm.foundation.parties.publicView.customerAccounts.CustomerAccountSitePVO")
    def getCustAcctSite = getCustAcctSitePVO.createViewCriteria()
    def getCustAcctSiteRow = getCustAcctSite.createViewCriteriaRow()
    getCustAcctSiteRow.setAttribute("PartySiteId", pShipToSiteId)
    def getCustAcctSiteRowSet = getCustAcctSitePVO.findByViewCriteria(getCustAcctSite, 1)
    def CustAcctSiteRec = getCustAcctSiteRowSet.first()
    if (CustAcctSiteRec != null) {
        Long custAcctId = CustAcctSiteRec?.getAttribute("CustAccountId")
        def getCustAcctContPVO = context.getViewObject("oracle.apps.financials.receivables.customers.publicView.analytics.AccountContactPVO")
        def getCustAcctCont = getCustAcctContPVO.createViewCriteria()
        def getCustAcctContRow = getCustAcctCont.createViewCriteriaRow()
        getCustAcctContRow.setAttribute("CustomerAccountContactCustAccountId", custAcctId)
        def getCustAcctContRowSet = getCustAcctContPVO.findByViewCriteria(getCustAcctCont, -1)
        return collectAllNotes(getCustAcctContRowSet)
    }
    return ""
}

// Fetch concatenated notes strings
def shipToNotes = getShipToSiteNotes(shipToPartySiteId)
def billToNotes = getBillToSiteNotes(billToPartySiteId)
def acctNotes = getAcctNotes(shipToPartySiteId)

// Collect unique, non-empty notes from all 3 sources
def noteSet = [] as LinkedHashSet
if (shipToNotes?.trim()) noteSet.add(shipToNotes.trim())
if (billToNotes?.trim()) noteSet.add(billToNotes.trim())
if (acctNotes?.trim()) noteSet.add(acctNotes.trim())


// Merge notes with semicolon if more than one unique, else single note or empty
String mergedInstructions = ""
if (noteSet.isEmpty()) {
    mergedInstructions = ""
} else if (noteSet.size() == 1) {
    mergedInstructions = noteSet.iterator().next()
} else {
    mergedInstructions = noteSet.join(" ; ")
}

// Truncate to max 995 chars
if (mergedInstructions.length() > 1000) {
    mergedInstructions = mergedInstructions.substring(0, 995)
}

// Set the ShippingInstructions attribute on the order header
header.setAttribute("ShippingInstructions", mergedInstructions)
