rm( list=ls() )
load( file='Rdata/pars.Rdata' )
source( '../code/ice_fxn.R' )
source( 'simfxn.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )
for( type in sample( types ) )
	for( meta in sample(1:2) )
{

	savefile	<-	paste0( 'Rdata/', 'ice', '_', meta, '_', type, '_', it, '_', 1, '_test.Rdata' )
	if( file.exists( savefile ) ) next
	sink(					paste0( 'Rout/'	, 'ice', '_', meta, '_', type, '_', it, '_', 1, '_test.Rout' ) )
	try({
		time	<- system.time({
			simdat	<- sim_fxn( seed=it, sig2_g=sig2_gs[type], ncaus=ncauss[type] )
			caus_p	<- simdat$caus_p
			Y				<- simdat$Y
			g				<- simdat$g
			rm( simdat )
			out		<- ice_summ_fxn( Y, g, ML=(meta==1) )
		})[3]
		cat( 'maintesttime=', time, '\n' )
		save( time, out, caus_p, file=savefile )
	})
	sink()

}
