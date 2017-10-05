rm( list=ls() )
load( file='Rdata/pars.Rdata' )
source( 'simfxn.R' )
source( '../fig3/mainfxn.R' )
source( '../code/make_peer.R' )
source( '../code/make_sva.R' )
source( '../code/make_smartsva.R' )
source( '../code/run_one_sim.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )
for( type in sample( types ) )
	for( fac in sample( factypes ) )
		for( dat_type in dat_types[1] )
			for( meta in 1:2 )
					for( r.i in 1:r.n )
{
	if( fac == 'ice' ) next

	savefile	<-	paste0( 'Rdata/', fac, '_', meta, '_', type, '_',dat_type, '_',r.i, '_', it, '.Rdata' )
	if( file.exists( savefile ) ) next
	sink(					paste0( 'Rout/'	, fac, '_', meta, '_', type, '_',dat_type, '_',r.i, '_', it, '.Rout' ) )
	tryCatch({

		simdat	<- sim_fxn( seed=it, sig2_x=sig2_xs[type], sig2_u=sig2_us[type], rho=sqrt(rho2s[r.i]), f=fs[type], dat_type=dat_type )
		caus_p	<- simdat$caus
		Y				<- simdat$Y
		g				<- simdat$g
		x				<- simdat$x
		rm( simdat )

		time	<- system.time({
			K	<- 12
			Z		<- mainfxn( fac, meta, g, K=K, x )
			if( fac == 'suporacle' & meta == 2 )
				K	<- 1
			out	<- run_one_sim( Y, g, Ks=K, Z=Z )
		})[3]
		cat( 'maintime=', time, '\n' )

		save( out, caus_p, file=savefile )

		rm( Y, Z, g, x, time, caus_p, out )

	}, error=function(e){ print( e ); print( c( type, meta, fac ) ) })
	sink()
}
