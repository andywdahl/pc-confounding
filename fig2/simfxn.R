sim_fxn	<- function( Y, seed, h2_g, gauss=F, ncaus=1 ){
	
	set.seed( seed )
	caus_p	<- sample( ncol(Y), ncaus, replace=F )

	if( ! gauss ){
		g						<- as.numeric(scale(rbinom( nrow(Y), 2, .2 )))
		Y[,caus_p]	<- sqrt(1-h2_g)*Y[,caus_p] + sqrt(h2_g)*g
	} else {
		g						<- rnorm(nrow(Y))
		Y[,caus_p]	<- Y[,caus_p] + sqrt(h2_g/(1-h2_g))*g
	}

	list( g=g, caus_p=caus_p, Y=Y )

}
