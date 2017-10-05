rm( list=ls() )
load( file='Rdata/pars.Rdata' )

source( '../code/simfxn.R' )
source( '../code/run_one_sim.R' )
source( '../code/make_peer.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )

for( a in sample(a.n) ){

	savefile	<- paste0( 'Rdata/peer_', a, '_', it, '.Rdata' )
	if( file.exists( savefile ) )
		next

	Y	<- matrix( rnorm( N*P ), N, P )
	simdat	<- sim_fxn( Y, seed=it, h2_g=as[a], gauss=TRUE, ncaus=1 )
	rm( Y )

	caus_p	<- simdat$caus_p

	time_1	<- system.time( pPCs	<- make_peer(simdat$Y, K=max(Ks)							) )[3]
	time_2	<- system.time( pPCs2	<- make_peer(simdat$Y, K=max(Ks), X=simdat$g	) )[3]

	time_3	<- system.time({
		out			<- run_one_sim( simdat$Y, simdat$g, Ks, Z=pPCs	)
		out_2		<- run_one_sim( simdat$Y, simdat$g, Ks, Z=pPCs2 )
	})[3]

	save( time_1, time_2, time_3, caus_p, out, out_2, file=savefile )

}
