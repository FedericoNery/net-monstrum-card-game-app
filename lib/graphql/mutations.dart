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
