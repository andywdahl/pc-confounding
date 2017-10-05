rm( list=ls() )
load( file='Rdata/pars.Rdata' )

source( '../code/simfxn.R' )
source( '../code/run_one_sim.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )

for( a in sample(a.n) ){

	savefile	<- paste0( 'Rdata/pc_', a, '_', it, '.Rdata' )
	if( file.exists( savefile ) )
		next

	Y	<- matrix( rnorm( N*P ), N, P )
	simdat	<- sim_fxn( Y, seed=it, h2_g=as[a], gauss=TRUE, ncaus=1 )
	rm( Y )
	g				<- simdat$g
	caus_p	<- simdat$caus_p

	time_1	<- system.time( PCs		<- svd( simdat$Y )$u					 )[3]
	time_2	<- system.time({
		proj	<- diag(N) - g%o%g/sum( g^2 )
		PCs2	<- svd( proj %*% simdat$Y )$u
	})[3]

	time_3	<- system.time({
		out			<- run_one_sim( simdat$Y, simdat$g, Ks, Z=PCs		)
		out_nomean			<- run_one_sim( simdat$Y, simdat$g, Ks, Z=PCs, nomean=T		)
		out_2		<- run_one_sim( simdat$Y, simdat$g, Ks, Z=PCs2 )
	})[3]

	save( time_1, time_2, time_3, caus_p, out, out_2, out_nomean, file=savefile )

}
