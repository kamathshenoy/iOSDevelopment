Project title
 	
 	Palaash or LiveGreen

Summary
	
	The purpose of this app called ‘Palaash’ or ‘LiveGreen’  is to enable the user to search for vegan or vegetarian recipes based on the ingredients available to the user. It lets user save some recipes as favorite recipes and also remove the recipe from favorite list. 

Detailed user flow

	The home scene has 2 tabs, 1st tab is used to search recipes. 2nd tab shows the saved favorite recipes.
	
Search Recipes scene:

1. The user can use the switch “Vegan” or “Vegetarian” to save their preferences. This choice is saved in NSUserDefaults  and retrieved when the app is relaunched. The default is “Vegetarian”.

2. The user can enter Cuisine, comma separated ingredients and the type of recipe they would like to make. 

3. After the Search Recipe button is tapped, the app transition to the next scene, Recipes scene to display the list of recipes. If the user does not make any selection on Search Recipe scene, trending vegetarian recipes are displayed.

4. On the Recipes scene, the name of the recipe and the picture of the dish is displayed.

5. On the Recipes scene, the user can click on Cancel to transition back to the Search Recipe scene.

6. On the Recipes scene, the user can click on the recipe to transition to next scene, Recipe Details scene. This displays all the ingredients and the process of making the dish in detail.

7. On the Recipes Details scene, the ‘heart’ on the right hand top can be used to make the recipe a ‘favorite recipe’. Or to remove a recipe from Favorites list.

8. On the Recipes Details scene, the user can click on Back to transition back to the list of recipes. Or to return back to the Favorite Recipe scene.

Favorite Recipe scene

1. The 2nd tab shows all the recipes that are marked as favorites. Initially when there are no favorite recipes, the scene is empty. This scene populates the data from CoreData, when the user makes any recipe a ‘favorite recipe’

2. From the Favorite recipe scene the user can click on each recipe to see the details. 

Prerequisites/Limitations

	This app supports iPhone 5 and iPhone 6 in portrait mode only. Other devices and landscape orientation is untested and will be released a later date. 

Installation and deployment 

 	Please download the code from github and execute the code using xCode. Please run the code in a simulator or using a iPhone 6 device.  Please use the Device Orientation in General setting to set the app in portrait mode.

API References

	This app uses the Rest based services provided by 
https://market.mashape.com/spoonacular/recipe-food-nutrition
The API key is built-in to the codebase.

Contributor

Sheethal Shenoy


For any questions please contact: sheethal.shenoy@gmail.com

