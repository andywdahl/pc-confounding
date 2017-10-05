rm( list=ls() )
load( file='Rdata/pars.Rdata' )
source( 'simfxn.R' )
source( '../fig3/mainfxn.R' )
source( '../code/make_peer.R' )
source( '../code/make_sva.R' )
source( '../code/make_smartsva.R' )
source( '../code/run_one_sim.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )
for( type in sample( setdiff( types, 'ice' ) ) )
	for( fac in sample( factypes ) )
		for( meta in 1:2 )
			for( splitid in 1:2 )
				for( dat_type in dat_types[1] )
					for( u.i in 1:u.n )
{

	savefile	<-	paste0( 'Rdata/', fac, '_', meta, '_', type, '_',splitid, '_',dat_type, '_',u.i, '_', it, '.Rdata' )
	if( file.exists( savefile ) ) next
	sink(					paste0( 'Rout/'	, fac, '_', meta, '_', type, '_',splitid, '_',dat_type, '_',u.i, '_', it, '.Rout' ) )
	tryCatch({

		simdat	<- sim_fxn( seed=it, sig2_x=sig2_xs[type], sig2_u=sig2_us[u.i], rho=sqrt(rho2s[type]), f=fs[type], dat_type=dat_type )
		caus_p	<- simdat$caus
		if( splitid == 1 ){
			sub	<- simdat$is
		} else {
			sub	<- (1:simdat$N)[-simdat$is]
		}
		Y				<- simdat$Y [sub,]
		g				<- simdat$g [sub]
		x				<- simdat$x [sub]
		rm( simdat )

		time	<- system.time({
			Z		<- mainfxn( ifelse( fac == 'oracle', 'suporacle', fac ), meta, g, K=12 )
			out	<- run_one_sim( Y, g, Ks=12, Z=Z )
		})[3]
		cat( 'maintime=', time, '\n' )

		save( out, caus_p, file=savefile )

		rm( Y, Z, g, x, time, caus_p, out )

	}, error=function(e){ print( e ); print( c( type, meta, fac ) ) })
	sink()
}
