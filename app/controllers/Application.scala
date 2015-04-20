package controllers

import play.api._
import play.api.mvc._

object Application extends Controller {

  def index1 = Action {
    try
    {
      throw new Exception("Exception thrown");
    }
    catch
    {
      case e: Exception => println("exception caught: " + e);
    }
    Ok(views.html.index("Hello World - This is my first scala application"))
  }

}
