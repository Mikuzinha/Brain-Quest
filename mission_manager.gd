extends Node

var missions = []


func adicionar_missao(titulo, descricao):
	var nova_missao = {
		"titulo": titulo,
		"descricao": descricao,
		"status": "EM ANDAMENTO"
	}

	missions.append(nova_missao)
