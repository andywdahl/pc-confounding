rm( list=ls() )
load( file='Rdata/pars.Rdata' )

source( '../code/simfxn.R' )
source( '../code/ice_fxn.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )

for( a in sample(a.n) ){

	savefile	<- paste0( 'Rdata/ice_', a, '_', it, '.Rdata' )
	if( file.exists( savefile ) )
		next

	Y	<- matrix( rnorm( N*P ), N, P )
	simdat	<- sim_fxn( Y, seed=it, h2_g=as[a], gauss=TRUE, ncaus=1 )
	rm( Y )
	caus_p	<- simdat$caus_p

	time_1	<- 0
	time_2	<- 0

	time_3	<- system.time({
		out		<- ice_summ_fxn( simdat$Y	, simdat$g, ML=TRUE )
		out_2	<- ice_summ_fxn( simdat$Y	, simdat$g, ML=FALSE )
	})[3]

	save( time_1, time_2, time_3, caus_p, out, out_2, file=savefile )

}
