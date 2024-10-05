String getUserByIdQuery = """
 query getUserById(\$id: String!){
  getUserById(id: \$id){
    email
    username
    folders{
      cards{
        ... on CardDigimon {
          __typename
          name
          color
          attackPoints
          healthPoints
          energyCount
          level
          evolution {
            name
          }
        }
        ... on CardEnergy {
          __typename
          name
          color
          energyCount
        }
        ... on CardSummonDigimon {
          __typename
          name
          digimonsCards{
            name
            color
            attackPointsCardSummonDigimon: attackPoints
            healthPointsCardSummonDigimon: healthPoints
            energyCount
            level
            evolution {
              name
            }
          }
        }
        ... on CardEquipment {
          __typename
          name
          attackPointsCardEquipment : attackPoints
          healthPointsCardEquipment : healthPoints
          quantityOfTargets
          targetScope
        }
      }
      name
      colors{
        green
        red
        blue
        white
        black
      }
    }
  }
}

""";
