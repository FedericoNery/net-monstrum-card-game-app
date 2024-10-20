String updateFolder = """
mutation updateFolder(\$userId: String!, \$folderId: String!, \$cardIds: [String!]!){
  updateFolder(updateFolderInput: {
    cardIds: \$cardIds, 
    folderId: \$folderId, 
    userId: \$userId})
  {
    cardNotExist
    folderNotFound
    reachedMaxCopiesOfCard
    successful
  }
}

""";

String purchaseCard = """
mutation purchaseCard(\$cardIdToPurchase: String!, \$userId: String!) {
  purchaseCard(purchaseCardInput: {cardIdToPurchase: \$cardIdToPurchase, userId: \$userId}) {
    cardNotFound
    insuficientCoins
    reachedMaxCopiesOfCard
    successful
  }
}
""";
