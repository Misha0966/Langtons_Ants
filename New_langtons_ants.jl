using Plots
using Colors
using FileIO
using ImageMagick
using Random
using Statistics

# Задаем цвета для каждого муравья
ant_colors = [RGB(1, 0, 0), RGB(0, 1, 0), RGB(0, 0, 1)] # Каждый цвет определен в формате RGB

# Начальные параметры
field_size = 300 # Размер поля
steps = 50000 # Количество шагов
field = fill(RGB(0, 0, 0), field_size, field_size)
directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]

# Инициализация муравьев
num_ants = 3
ant_x = rand(1:field_size, num_ants) # начальные координаты x для каждого муравья
ant_y = rand(1:field_size, num_ants) # начальные координаты y для каждого муравья
ant_direction = fill(1, num_ants) # начальное направление для каждого муравья

# Функция для обновления состояния поля и муравьев
function update_ants!(ant_x, ant_y, ant_direction, field, steps)
    for i in 1:steps
        for j in 1:num_ants
            x, y, direction = ant_x[j], ant_y[j], ant_direction[j]
            if field[x, y] == ant_colors[j] # Проверяем цвет на поле
                ant_direction[j] = mod1(direction + 1, 4)
                field[x, y] = RGB(1, 1, 1) # Если цвет соответствует текущему муравью, меняем на белый
            else
                ant_direction[j] = mod1(direction - 1, 4)
                field[x, y] = ant_colors[j] # Если цвет не соответствует текущему муравью, меняем на его цвет
            end
            ant_x[j] = mod1(x + directions[ant_direction[j]][1], field_size)
            ant_y[j] = mod1(y + directions[ant_direction[j]][2], field_size)
        end
    end
end

# Создаем анимацию
anim = @animate for i in 1:steps
    heatmap(field, c=:grays, colorbar=false, axis=false, size=(800, 800))
    update_ants!(ant_x, ant_y, ant_direction, field, 1)
end

gif(anim, "langtons_ants.gif", fps = 60)