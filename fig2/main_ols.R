rm( list=ls() )
load( file='Rdata/pars.Rdata' )

source( '../code/simfxn.R' )
source( '../code/run_one_sim.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )

for( a in sample(a.n) ){

	savefile	<- paste0( 'Rdata/ols_', a, '_', it, '.Rdata' )
	if( file.exists( savefile ) )
		next

	Y	<- matrix( rnorm( N*P ), N, P )
	simdat	<- sim_fxn( Y, seed=it, h2_g=as[a], gauss=TRUE, ncaus=1 )
	rm( Y )
	caus_p	<- simdat$caus_p

	time_1	<- 0
	time_2	<- 0

	time_3	<- system.time({
		out			<- run_one_sim( simdat$Y, simdat$g, Ks, Z=NULL )
	})[3]

	save( time_1, time_2, time_3, caus_p, out, file=savefile )
		
	rm( out )

}
