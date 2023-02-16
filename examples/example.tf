# update this to demonstrate usage 
# of the module. If there are more 
# than one examples that you want 
# to demonstrate, create additional files in
# this directory and name them logically. 

module "this" {
  source = "../"

  app         = "example"
  environment = "dev"
  program     = "example"
}