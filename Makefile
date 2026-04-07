.PHONY: up down restart logs status pull setup

INFRA_DIR := infra

up:
	@cd $(INFRA_DIR) && bash deploy.sh up

down:
	@cd $(INFRA_DIR) && bash deploy.sh down

restart:
	@cd $(INFRA_DIR) && bash deploy.sh restart

logs:
	@cd $(INFRA_DIR) && bash deploy.sh logs $(filter-out $@,$(MAKECMDGOALS))

status:
	@cd $(INFRA_DIR) && bash deploy.sh status

pull:
	@cd $(INFRA_DIR) && bash deploy.sh pull

setup:
	@echo "환경 파일 생성 중..."
	@cp -n $(INFRA_DIR)/env/bot.env.example $(INFRA_DIR)/env/bot.env 2>/dev/null || true
	@cp -n $(INFRA_DIR)/env/db.env.example $(INFRA_DIR)/env/db.env 2>/dev/null || true
	@cp -n $(INFRA_DIR)/env/llm.env.example $(INFRA_DIR)/env/llm.env 2>/dev/null || true
	@echo "$(INFRA_DIR)/env/ 아래 env 파일들을 수정해주세요."

dev:
	@cd $(INFRA_DIR) && docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build

%:
	@:
