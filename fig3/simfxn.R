library(phenix)
sim_fxn	<- function( seed, sig2_g, ncaus ){

	load( '../geuvadis/processed_data/Y_final.Rdata' )
	
	set.seed( seed )
	caus_p	<- sample( ncol(Y), ncaus, replace=F )

	N				<- nrow(Y)
	P				<- ncol(Y)

	beta_g	<- sqrt(P/ncaus)* rnorm( ncaus )

	g				<- rbinom( N, 2, .2 )
	g				<- ( g - mean(g) )/sd(g)

	Y						<- sqrt(1-sig2_g) * scale(Y)
	Y[,caus_p]	<- Y[,caus_p] + sqrt(sig2_g)*( g %o% beta_g )
	Y						<- scale( Y )

	list( g=g, caus_p=caus_p, Y=Y )

}
