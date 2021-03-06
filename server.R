library(shiny)

# Define server logic required to draw the plots and find probabilities
shinyServer(function(input, output,session) {
 
  observe({
    dist <- input$dist
      
    if (dist=="Binomial"){
      updateNumericInput(session, "param1", label="Sample Size, n",value = 30,step=1,min=0)
      updateNumericInput(session, "param2", label="Probability of Success, p",value = 0.5,step=0.01,min=0,max=1)
    } else if (dist=="Poisson") {
      updateNumericInput(session, "param1", label="Lambda (Mean)",value = 30,min=0,step=1)
    }  
    
  })

  output$distPlot<-renderPlot({
    #input distribution
    dist<-input$dist
    
    #sample size
    normal<-input$overlay
    color<-input$color  
    color2<-input$color2
    
    #shading stuff
    Lower<-input$probL
    Upper<-input$probU
      
    if (is.integer(Lower)==FALSE){
      Lower<-ceiling(Lower)
    }
    
    if (is.integer(Upper)==FALSE){
      Upper<-floor(Upper)
    }     
      
    if (dist=="Binomial") {
      #parameters
      n<-input$param1
      prob<-input$param2
      #Plotting sequence
      x <- seq(from=0,to=n,by=1)
      #draw the parent distribution plot
      plot(x=x,y=dbinom(x=x,size=n,prob=prob),main=paste(dist," Density"),xlab="y", ylab="f(y)",type="h")

      if (normal){
        normx<-seq(from=0,to=n*prob+4*n*prob*(1-prob)+100,length=5000)
        lines(normx,dnorm(normx,mean=n*prob,sd=sqrt(n*prob*(1-prob))))
        
        #add plot fill if requested
        if (color&(!is.na(Lower))&(!is.na(Upper))){
          shortseq<-seq(from=Lower,to= Upper,by=0.005)
          polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=n*prob,sd=sqrt(n*prob*(1-prob))))),col=rgb(0.3,0.1,0.5,0.3))
        }
        
        #add plot fill if requested (for cc)
        if (color2&(!is.na(Lower))&(!is.na(Upper))){
          shortseq<-seq(from=Lower-0.5,to= Upper+0.5,by=0.005)
          polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=n*prob,sd=sqrt(n*prob*(1-prob))))),col=rgb(0.8,0.4,0.1,0.3))
        }
        
      }
    } else if (dist=="Poisson") {
      #parameters
      lambda<-input$param1
      
      #Plotting sequence
      x <- seq(from=0,to=lambda+4*sqrt(lambda),by=1)
      
      #draw the parent distribution plot
      plot(x=x,y=dpois(x=x,lambda=lambda),main=paste(dist," Density"),xlab="y", ylab="f(y)",type="h")
      
      if(normal){
        normx<-seq(from=0,to=lambda+4*sqrt(lambda),length=5000)
        lines(normx,dnorm(normx,mean=lambda,sd=sqrt(lambda)))

        #add plot fill if requested        
        if (color&(!is.na(Lower))&(!is.na(Upper))){
          shortseq<-seq(from=Lower,to= Upper,by=0.005)
          polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=lambda,sd=sqrt(lambda)))),col=rgb(0.3,0.1,0.5,0.3))
        }

        #add plot fill if requested (for cc)        
        if (color2&(!is.na(Lower))&(!is.na(Upper))){
          shortseq<-seq(from=Lower-0.5,to= Upper+0.5,by=0.005)
          polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=lambda,sd=sqrt(lambda)))),col=rgb(0.8,0.4,0.1,0.3))
         }
      }
    } 
  })
  
  output$probTable<-renderTable({

    #get inputs
    Lower<-input$probL
    Upper<-input$probU
    dist<-input$dist
    
    if (is.integer(Lower)==FALSE){
      Lower<-ceiling(Lower)
    }
    
    if (is.integer(Upper)==FALSE){
      Upper<-floor(Upper)
    }    
    
    #Find probabilities
    if (dist=="Binomial"){
      n<-input$param1
      prob<-input$param2

      #exact
      probExact<-pbinom(q=Upper,size=n,prob=prob)-pbinom(q=Lower-1,size=n,prob=prob)
      
      #Norm approx
      probNorm<-pnorm(q=Upper,mean=n*prob,sd=sqrt(n*prob*(1-prob)))-pnorm(q=Lower,mean=n*prob,sd=sqrt(n*prob*(1-prob)))
      
      #Norm approx with cc
      probNormCC<-pnorm(q=Upper+0.5,mean=n*prob,sd=sqrt(n*prob*(1-prob)))-pnorm(q=Lower-0.5,mean=n*prob,sd=sqrt(n*prob*(1-prob)))
      
    } else if (dist=="Poisson"){
      lambda<-input$param1
      
      #Exact
      probExact<-ppois(q=Upper,lambda=lambda)-ppois(q=Lower-1,lambda=lambda)
      
      #Norm Approx
      probNorm<-pnorm(q=Upper,mean=lambda,sd=sqrt(lambda))-pnorm(q=Lower,mean=lambda,sd=sqrt(lambda))
      
      #Norm Approx with cc
      probNormCC<-pnorm(q=Upper+0.5,mean=lambda,sd=sqrt(lambda))-pnorm(q=Lower-0.5,mean=lambda,sd=sqrt(lambda))
      
    }
    
    #put results in data frame to display
    probMat<-data.frame(Method=c("Exact Probability","Normal Approx","Normal Approx with CC"),Probability=c(sprintf("%.4f",probExact),sprintf("%.4f",probNorm),sprintf("%.4f",probNormCC)))
    
    #return data frame
    probMat
  })
    
})    
