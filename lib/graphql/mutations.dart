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

String signInWithEmail = """
mutation signInWithEmail(\$email: String!) {
  signInWithEmail(email: \$email) {
    access_token
  }
}
""";

String createUserWithEmailAndUsername = """
mutation createUserWithEmail(\$email: String!, \$username: String!, \$avatarUrl: String!) {
  createUserByEmail(createUserInput: { email: \$email, username: \$username, avatarUrl: \$avatarUrl} ) {
    result{
      id
      username
    }
    successfull
    userAlreadyExist
    hasError
  }
}
""";
