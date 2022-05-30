# This line ensures Ruby files in `lib` can be loaded in your server
# with `require` rather than `require_relative`
$:.unshift File.join(File.dirname(__FILE__), 'lib')

# require_relative "./app"
require_relative "app/controllers/user_controller"
require_relative "app/controllers/catboard_controller"
require_relative "app/controllers/campaign_controller"

# This line runs your server
run CatboardController
use UserController
use CampaignController
